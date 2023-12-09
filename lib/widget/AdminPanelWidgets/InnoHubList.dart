import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import '../../datamanager/InnovationHub.dart';
import '../../datamanager/InnovationHubProvider.dart';

class AdminInnoHubList extends StatelessWidget {
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
            List<InnovationHub> filteredHubs = provider.allinnovationHubs;

            return ListView.builder(
              itemCount: filteredHubs.length,
              itemBuilder: (context, index) =>
                  AdminHubListItem(hub: filteredHubs[index]),
            );
          },
        ),
      ),
    );
  }
}

class AdminHubListItem extends StatelessWidget {
  final InnovationHub hub;


  AdminHubListItem({required this.hub});

  @override
  Widget build(BuildContext context) {
    return Consumer<InnovationHubProvider>(
        builder: (context, provider, child) {
          //provider.calculate_recomendations(hub);
          return Container(
            child: Row(
              children: [
                Text(hub.name),
                Text(hub.status),

              ],
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