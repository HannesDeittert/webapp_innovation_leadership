import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

import '../datamanager/DetailedHubInfoProvider.dart';
import '../datamanager/EventProvieder.dart';
import '../datamanager/InnovationHub.dart';
import '../datamanager/InnovationHubProvider.dart';
import '../datamanager/WorkProvider.dart';
import 'innovationhubdetailpage.dart';

class InnoHubGridWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: 10,
          vertical: MediaQuery.of(context).size.height/20
        ),
        child: Container(
          child: Consumer<InnovationHubProvider>(
            builder: (context, provider, child) {
              // Liste der gefilterten Hubs abrufen
              List<InnovationHub> filteredHubs = provider.filteredHubs;

              return GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 5, // Anzahl der Spalten in der Grid-Ansicht
                  mainAxisSpacing: 8.0, // Abstand zwischen den Zeilen
                ),
                itemCount: filteredHubs.length,
                itemBuilder: (context, index) =>
                    HubGridTile(hub: filteredHubs[index]),
              );
            },
          ),
        ),
      ),
    );
  }
}

class HubGridTile extends StatelessWidget {
  final InnovationHub hub;

  HubGridTile({required this.hub});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        DetailedHubInfoProvider provider = Provider.of<DetailedHubInfoProvider>(context, listen: false);
        InnovationHubProvider provider2 = Provider.of<InnovationHubProvider>(context, listen: false);
        EventProvider provider3 = Provider.of<EventProvider>(context, listen: false);
        WorkProvider provider4 = Provider.of<WorkProvider>(context, listen: false);
        await provider.getHubInfoByCode(hub.code);
        await provider.getMenu();
        provider2.calculate_recomendations(provider2.getInnovationHubByCode(hub.code));
        await provider3.loadAllEvents();
        await provider3.getEventListFromUidList(provider.detailedInnovationHub.events);
        await provider4.loadAllHubworks();
        await provider4.getHubworksListFromUidList(provider.detailedInnovationHub.work);

        // Zur Detailseite navigieren
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => InnovationHubDetailPage(),
          ),
        );
      },
      child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Hier kannst du das Profilbild anzeigen
            Expanded(
              child: FutureBuilder(
                future: _loadProfileImage(hub.profileImagePath),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    return Image(
                      image: snapshot.data as ImageProvider,
                      fit: BoxFit.cover,
                    );
                  } else {
                    return Container(); // Hier könnte ein Ladeindikator eingefügt werden
                  }
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: Text(
                hub.name,
                style: TextStyle(fontSize: 30, color: Color.fromARGB(0xFF, 0x55, 0x55, 0x55)),
              ),
            ),
          ],
        ),
      );
  }

  Future<ImageProvider> _loadProfileImage(String path) async {
    try {
      final ref = firebase_storage.FirebaseStorage.instance.ref(path);
      final url = await ref.getDownloadURL();
      return NetworkImage(url);
    } catch (e) {
      // Fehlerbehandlung, wenn das Bild nicht geladen werden kann
      print('Fehler beim Laden des Profilbildes: $e');
      return AssetImage('assets/placeholder_image.jpg');
    }
  }
}