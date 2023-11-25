import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:webapp_innovation_leadership/datamanager/DetailedHubInfo.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

import '../datamanager/DetailedHubInfoProvider.dart';

import '../login/login_screen.dart';

class InnovationHubDetailPage extends StatefulWidget {


  @override
  _InnovationHubDetailPageState createState() => _InnovationHubDetailPageState();
}

class _InnovationHubDetailPageState extends State<InnovationHubDetailPage> {
  final String imagePath = 'Images/FAU_INNOVATION_LOGO.png';

  Future<Widget> _loadLeadingImage() async {
    try {
      final ref = firebase_storage.FirebaseStorage.instance.ref(imagePath);
      final url = await ref.getDownloadURL();
      print(url);

      // Lade das Bild von der URL
      final imageWidget = Image.network(url);

      // Du kannst die Größe des Bildes anpassen, indem du eine `Container`-Umgebung verwendest
      return Container(
        width: 100, // Ändere dies nach Bedarf
        height: 100, // Ändere dies nach Bedarf
        child: imageWidget,
      );
    } catch (e) {
      print('Fehler beim Laden des Bildes: $e');
      // Hier könntest du ein Standardbild zurückgeben oder eine Fehlermeldung anzeigen
      return Image.asset(
          'assets/placeholder_image.jpg'); // Beispiel für ein Standardbild
    }
  }

  @override
  Widget build(BuildContext context) {
    // Zugriff auf den InnovationHubProvider
    DetailedHubInfoProvider provider =
        Provider.of<DetailedHubInfoProvider>(context);

    // Liste der gefilterten Hubs abrufen
    DetailedHubInfo Info = provider.detailedInnovationHub;
    return Scaffold(
      body: Container(
        color: Colors.white,
        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border(
                    bottom: BorderSide(
                        width: 1, color: Color.fromARGB(0xFF, 0x55, 0x55, 0x55)),
                  )),
              child: Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: MediaQuery.of(context).size.width / 30,
                    vertical: 0.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    FutureBuilder(
                      future: _loadLeadingImage(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.done) {
                          // Wenn das Bild geladen wurde, zeige es an
                          return snapshot.data!;
                        } else if (snapshot.hasError) {
                          // Wenn ein Fehler aufgetreten ist, zeige eine Fehlermeldung an
                          return Icon(Icons
                              .error); // Hier könntest du eine andere Fehleranzeige verwenden
                        } else {
                          // Ansonsten zeige einen Ladeindikator oder ein Platzhalterbild an
                          return CircularProgressIndicator();
                        }
                      },
                    ),
                    IconButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => LoginScreen()),
                          );
                        },
                        icon: Icon(Icons.login, color: Colors.black))
                  ],
                ),
              ),
            ),

            Container(
              color: Colors.white,
              child: Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: MediaQuery.of(context).size.width / 30,
                    vertical: 25),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width / 4,
                      child: Column(
                        children: [
                          Container(

                          )
                        ],
                      ),
                    ),
                    Column(
                      children: [
                        FutureBuilder(
                          future: _loadProfileImage(Info.headerImage),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState == ConnectionState.done) {
                              return SizedBox(
                                height: (MediaQuery.of(context).size.width *(2.5/4))*0.427,
                                width: MediaQuery.of(context).size.width *(2.5/4),
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
                        Container(
                            width: MediaQuery.of(context).size.width *(2.5/4),
                            child: Text(Info.name)),
                        Container(
                          width: MediaQuery.of(context).size.width *(2.5/4),
                            child: Text(Info.detailedDescription)),
                        // ... Weitere Informationen für den InnovationHub anzeigen
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
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