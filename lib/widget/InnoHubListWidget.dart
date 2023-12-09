import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

import '../datamanager/DetailedHubInfoProvider.dart';
import '../datamanager/InnovationHub.dart';
import '../datamanager/InnovationHubProvider.dart';
import 'innovationhubdetailpage.dart';
import '../datamanager/DetailedHubInfoProvider.dart';

class InnoHubListWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: MediaQuery.of(context).size.width / 30,
          vertical: MediaQuery.of(context).size.height / 30,
        ),
        child: Consumer<InnovationHubProvider>(
          builder: (context, provider, child) {
            // Liste der gefilterten Hubs abrufen
            List<InnovationHub> filteredHubs = provider.filteredHubs;

            return ListView.builder(
              itemCount: filteredHubs.length,
              itemBuilder: (context, index) =>
                  HubListItem(hub: filteredHubs[index]),
            );
          },
        ),
      ),
    );
  }
}

class HubListItem extends StatelessWidget {
  final InnovationHub hub;


  HubListItem({required this.hub});

  @override
  Widget build(BuildContext context) {
    return Consumer<InnovationHubProvider>(
        builder: (context, provider, child) {
          //provider.calculate_recomendations(hub);
          return GestureDetector(
            onTap: () async {
              // Den DetailedHubInfoProvider vom Kontext abrufen
              DetailedHubInfoProvider detailedHubInfoProvider =
              Provider.of<DetailedHubInfoProvider>(context, listen: false);
              // _detailedHubInfo über die loadDetailedHubInfo-Methode initialisieren
              await detailedHubInfoProvider.getHubInfoByCode(hub.code);
              await detailedHubInfoProvider.getMenu();
              print(detailedHubInfoProvider.detailedInnovationHub);
              provider.calculate_recomendations(hub);
              print(provider.recomendations);
              // Zur Detailseite navigieren
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => InnovationHubDetailPage(),
                ),
              );
            },
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Hier kannst du das Profilbild anzeigen
                    FutureBuilder(
                      future: _loadProfileImage(hub.profileImagePath),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.done) {
                          return SizedBox(
                            height: MediaQuery
                                .of(context)
                                .size
                                .height / 4,
                            width: MediaQuery
                                .of(context)
                                .size
                                .height / 4,
                            child: Image(
                              image: snapshot.data as ImageProvider,
                              fit: BoxFit.cover,
                            ),
                          );
                        } else {
                          return Container(); // Hier könnte ein Ladeindikator eingefügt werden
                        }
                      },
                    ),
                    SizedBox(width: 10),
                    Container(
                      height: MediaQuery
                          .of(context)
                          .size
                          .height / 4,
                      width: MediaQuery
                          .of(context)
                          .size
                          .width * 0.5,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,

                        children: [
                          Text(
                            hub.name,
                            style: TextStyle(fontSize: 32,
                                fontWeight: FontWeight.bold,
                                color: Color.fromARGB(0xFF, 0x55, 0x55, 0x55)),
                          ),
                          Text(
                            hub.summary,
                            style: TextStyle(fontSize: 32,
                                color: Color.fromARGB(0xFF, 0x55, 0x55, 0x55)),
                          ),
                          SizedBox(height: MediaQuery
                              .of(context)
                              .size
                              .height / 20),

                          Wrap(
                            spacing: 5,
                            children: hub.filtered_chips.map((chip) {
                              return Chip(
                                label: Text(chip, style: TextStyle(
                                  fontSize: 20,
                                  color: Color.fromARGB(0xFF, 0x55, 0x55, 0x55),
                                ),),
                              );
                            }).toList(),
                          ),
                        ],
                      ),
                    ),

                  ],
                ),
              ),
            ),
          );
        }
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