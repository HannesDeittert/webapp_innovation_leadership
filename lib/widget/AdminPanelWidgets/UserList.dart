import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import '../../datamanager/InnovationHub.dart';
import '../../datamanager/InnovationHubProvider.dart';
import '../../datamanager/User.dart';
import '../../datamanager/UserProvider.dart';

class UserList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: MediaQuery.of(context).size.width / 30,
          vertical: MediaQuery.of(context).size.height / 30,
        ),
        child: Consumer<UserProvider>(
          builder: (context, provider, child) {
            // Liste der gefilterten Hubs abrufen
            List<MyUser> filteredHubs = provider.user;

            return ListView.builder(
              itemCount: filteredHubs.length,
              itemBuilder: (context, index) =>
                  AdminUserListItem(user: filteredHubs[index]),
            );
          },
        ),
      ),
    );
  }
}

class AdminUserListItem extends StatelessWidget {
  final MyUser user;


  AdminUserListItem({required this.user});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
            child: Row(
              children: [
                Text(user.email),
                Text(user.role),

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