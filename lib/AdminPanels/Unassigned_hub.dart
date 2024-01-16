import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:webapp_innovation_leadership/Homepage.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

import '../datamanager/InnovationHubProvider.dart';
import '../datamanager/QuestionProvider.dart';

///ToDo: Implement that user are only able to be in this page as long as there Status is = loggedIn

class unassigned_hub extends StatefulWidget {
  const unassigned_hub({Key? key}) : super(key: key);

  @override
  _unassigned_hub createState() => _unassigned_hub();
}

class _unassigned_hub extends State<unassigned_hub> {
  late User _user;
  final InnovationHubProvider provider = InnovationHubProvider();


  @override
  void initState() {
    super.initState();
    _user = FirebaseAuth.instance.currentUser!;
    provider.loadInnovationHubsFromFirestore();

  }

  final String imagePath = 'Images/FAU_INNOVATION_LOGO.png';

  Future<Widget> _loadLeadingImage() async {
    try {
      final ref = firebase_storage.FirebaseStorage.instance.ref(imagePath);
      final url = await ref.getDownloadURL();

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
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border(
                    bottom: BorderSide(
                        width: 1,
                        color: Color.fromARGB(0xFF, 0x55, 0x55, 0x55)),
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
                    Column(children: [
                      Text('Welcome, ${_user.email}'),
                      SizedBox(height: 20),
                      Text('User ID: ${_user.uid}'),
                    ],),
                    IconButton(
                        onPressed: () async {
                          await FirebaseAuth.instance.signOut();
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => MyHomePage()),
                          );
                        },
                        icon: Icon(Icons.logout, color: Colors.black))
                  ],
                ),
              ),
            ),
            SizedBox(height: 20),
            Text(
              'You are currently not assigned a role in this project, if this does not change in the next few workdays, please contact your contact person of the project! \n Thank you for your patience!',
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                // Hier fügst du die Aktion zum Abmelden hinzu
                await FirebaseAuth.instance.signOut();
                // Optional: Du kannst den Benutzer dann zu einer anderen Seite navigieren
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => MyHomePage()),
                );
              },
              child: Text('Sign Out'),
            ),
          ],
        ),
      ),
    );
  }
}
