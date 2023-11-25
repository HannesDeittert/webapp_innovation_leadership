import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:side_sheet/side_sheet.dart';
import 'package:webapp_innovation_leadership/datamanager/QuestionProvider.dart';
import 'package:webapp_innovation_leadership/home.dart';
import 'package:webapp_innovation_leadership/widget/FilterWidgets/mainFilterUI.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'datamanager/InnovationHubProvider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'login/login_screen.dart';


class MyHomePage extends StatelessWidget {
  final InnovationHubProvider provider = InnovationHubProvider();
  final QuestionProvider provider2 = QuestionProvider();
  bool isListViewSelected = true;


  @override
  void initState() {
    provider.loadInnovationHubsFromFirestore();
    provider2.loadQuestionsFromFirestore();
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
                        padding: EdgeInsets.symmetric(vertical: 20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Row(
                              children: [
                                Text(
                                  'FAU',
                                  style: GoogleFonts.lilitaOne(fontSize: 128,color: Color.fromARGB(0xFF, 0x55, 0x55, 0x55)),
                                ),
                                SizedBox(height: 5),
                                Column(
                                    children: [
                                    SizedBox(
                                      height: MediaQuery.of(context).size.height/30,
                                    ),
                                    Text(
                                    "Inno Hub",
                                    style: GoogleFonts.pacifico(fontSize: 40,color: Color.fromARGB(0xFF, 0x55, 0x55, 0x55))
                                  ),
                        ]
                                )
                              ],
                            ),
                            Text(
                              'Discover our innovation facilities and become \na part of the FAU innovation journey',
                              style: TextStyle(fontSize: 50,color: Color.fromARGB(0xFF, 0x55, 0x55, 0x55)),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 20),
                      Row(
                              children: [

                                TextButton(
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(builder: (context) => FilterUI()),
                                    );
                                    // Aktion für den weißen Button mit schwarzer Umrandung
                                  },
                                  style: TextButton.styleFrom(
                                      backgroundColor: Color.fromARGB(0xFF, 0x0F, 0x62, 0xFE),
                                      side: BorderSide(color: Colors.black),
                                      fixedSize: Size(MediaQuery.of(context).size.width/9, MediaQuery.of(context).size.height/30)
                                  ),
                                  child: Text(
                                    'Personal Reccomendations',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 20,
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: MediaQuery.of(context).size.width/80,
                                ),
                                OutlinedButton(
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(builder: (context) => Home()),
                                    );
                                    // Aktion für den weißen Button mit schwarzer Umrandung
                                  },
                                  style: OutlinedButton.styleFrom(
                                    side: BorderSide(color: Colors.black),
                                    fixedSize: Size(MediaQuery.of(context).size.width/20, MediaQuery.of(context).size.height/30)
                                  ),
                                  child: Text(
                                    'View All',
                                    style: TextStyle(
                                      color: Color.fromARGB(0xFF, 0x55, 0x55, 0x55),
                                      fontSize: 20,
                                    ),
                                  ),
                                ),
                              ],
                            ),
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

Widget PopUPContent(BuildContext context) {

  return Container(
    width: MediaQuery.of(context).size.width * 0.2,
    padding: EdgeInsets.all(16),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,

      children: [
        // Container 2
        Container(
          width: MediaQuery.of(context).size.width * 0.17,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            border: Border.all(),
          ),
          child: Column(
            children: [
              IconButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => LoginScreen()),
                    );
                  }, icon: Icon(Icons.login, color: Colors.black))
            ],
          ),
        ),

        SizedBox(
          height: 10,
        ),
        // Container 4
        Container(
          width: MediaQuery.of(context).size.width * 0.17,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            border: Border.all(),
          ),
          child: Column(
            children: [
              Text("General", style: TextStyle(fontWeight: FontWeight.bold),),
              // Textzeilen, die anklickbar sind
              buildClickableText("Tips & Tricks"),
              buildClickableText("About Us"),
              buildClickableText("FAQs"),
              buildClickableText("Sources & References"),
              buildClickableText("Feedback"),
              buildClickableText("Questions"),
            ],
          ),
        ),

        SizedBox(
          height: 10,
        ),

        // Container 5
        Container(
          width: MediaQuery.of(context).size.width * 0.17,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            border: Border.all(),
          ),
          child: Column(
            children: [
              // Hier den Code für das Development Impressum einfügen
              Text("Development Impressum", style: TextStyle(fontWeight: FontWeight.bold),),
              Text("Hannes Deittert"),
              Text("hannes.deittert@fau.de"),
              Text("Bohlenplatz 10 91054"),
              Text("Erlangen"),
            ],
          ),
        ),

      ],
    ),
  );
}

Widget buildClickableText(String text) {
  return GestureDetector(
    onTap: () {
      // Hier den Code für die Aktion bei Klick auf den Text einfügen
      print("$text wurde geklickt.");
    },
    child: Text(
      text,
      style: TextStyle(
        decoration: TextDecoration.underline,
        color: Colors.blue,
      ),
    ),
  );
}
