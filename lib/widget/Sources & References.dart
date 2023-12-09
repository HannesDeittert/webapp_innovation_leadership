import 'package:flutter/cupertino.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:flutter/material.dart';
import 'package:side_sheet/side_sheet.dart';

import '../Homepage.dart';
import 'PopUpContent.dart';

class Sources extends StatelessWidget {
  bool isListViewSelected = true;
  
  final String imagePath = 'Images/FAU_INNOVATION_LOGO.png';

  Future<Widget> _loadLeadingImage() async {
    try {
      final ref = firebase_storage.FirebaseStorage.instance.ref(imagePath);
      final url = await ref.getDownloadURL();

      // Lade das Bild von der URL
      final imageWidget = Image.network(url);

      // Du kannst die Größe des Bildes anpassen, indem du eine `Container`-Umgebung verwendest
      return Container(
        width: 100,  // Ändere dies nach Bedarf
        height: 100,  // Ändere dies nach Bedarf
        child: imageWidget,
      );
    } catch (e) {
      print('Fehler beim Laden des Bildes: $e');
      // Hier könntest du ein Standardbild zurückgeben oder eine Fehlermeldung anzeigen
      return Image.asset('assets/placeholder_image.jpg'); // Beispiel für ein Standardbild
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          Container(
            decoration: BoxDecoration(
                color: Colors.white,
                border: Border(
                  bottom: BorderSide(
                      width: 1,
                      color: Color.fromARGB(0xFF, 0x55, 0x55, 0x55)),
                )
            ),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width/30,vertical: 0.0 ),
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
                        return Icon(Icons.error); // Hier könntest du eine andere Fehleranzeige verwenden
                      } else {
                        // Ansonsten zeige einen Ladeindikator oder ein Platzhalterbild an
                        return CircularProgressIndicator();
                      }
                    },
                  ),
                  IconButton(
                      onPressed: () {
                        /*Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => LoginScreen()),
                          );*/
                        SideSheet.right(
                            sheetBorderRadius: 10,
                            context: context,
                            width: MediaQuery.of(context).size.width * 0.2,
                            body: PopUPContent(context)
                        );
                      }, icon: Icon(Icons.menu, color: Colors.black))
                ],
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width/30,vertical: 0.0 ),
            child: Column(
              children: [
                Container(
                  child: Column(
                      children: [
                        SizedBox(height: MediaQuery.of(context).size.height/5),
                        Container(
                          child: Column(children: [
                            Text("People illustrations by Storyset:"),
                            Text("https://storyset.com/people"),
                            Text("Business illustrations by Storyset:"),
                            Text("https://storyset.com/business"),
                            Text("Education illustrations by Storyset:"),
                            Text("https://storyset.com/education"),
                            Text("Job illustrations by Storyset:"),
                            Text("https://storyset.com/job"),
                          ],),
                        )
                      ]
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}