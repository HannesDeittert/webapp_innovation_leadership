// Filter Dropdown Komponente
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../datamanager/DetailedHubInfoProvider.dart';
import '../datamanager/InnovationHub.dart';
import '../datamanager/InnovationHubProvider.dart';
import 'innovationhubdetailpage.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;


// Hub List Tile Komponente
class HubListTile extends StatelessWidget {
  final InnovationHub hub;

  HubListTile({required this.hub});

  @override
  Widget build(BuildContext context) {
    // Zugriff auf den InnovationHubProvider
    InnovationHubProvider provider =
    Provider.of<InnovationHubProvider>(context);
    return ListTile(
      leading: FutureBuilder(
        future: _loadProfileImage(hub.profileImagePath),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return CircleAvatar(
              backgroundImage: snapshot.data as ImageProvider,
            );
          } else {
            return CircleAvatar(); // Hier könnte ein Ladeindikator eingefügt werden
          }
        },
      ),
      title: Text(hub.name),
      onTap: () async {
        // Den DetailedHubInfoProvider vom Kontext abrufen
        DetailedHubInfoProvider detailedHubInfoProvider =
        Provider.of<DetailedHubInfoProvider>(context, listen: false);

        // _detailedHubInfo über die loadDetailedHubInfo-Methode initialisieren
        await detailedHubInfoProvider.getHubInfoByCode(hub.code);

        // Zur Detailseite navigieren
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => InnovationHubDetailPage(),
          ),
        );
      },
    );
  }

  IconData getIconForCategory(String category) {
    switch (category) {
      case 'university':
        return Icons.school;
      case 'company':
        return Icons.business;
      case 'socialInstitution':
        return Icons.group;
      case 'StartUp':
        return Icons.star;
      default:
        return Icons.info;
    }
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