import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:webapp_innovation_leadership/widget/FilterWidgets/mainFilterUI.dart';
import 'package:webapp_innovation_leadership/widget/InnoHubGrid.dart';
import 'package:webapp_innovation_leadership/widget/InnoHubListWidget.dart';
import 'package:webapp_innovation_leadership/widget/map.dart';
import 'login/login_screen.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  bool isListViewSelected = true;
  bool isGridViewSelected = false;
  bool isMapViewSelected = false;
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
    return Scaffold(
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
                  )
              ),
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
                        if (snapshot.connectionState ==
                            ConnectionState.done) {
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
                    vertical: 0.0),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 20),
                      child: Row(
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Discover our innovation facilities one by one or use the interactive map",
                                style: TextStyle(
                                    fontSize: 18,
                                    color:
                                        Color.fromARGB(0xFF, 0x55, 0x55, 0x55)),
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              // Buttons to switch between ListView and MapView
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  OutlinedButton(
                                    onPressed: () {
                                      setState(() {
                                        isListViewSelected = true;
                                        isGridViewSelected = false;
                                        isMapViewSelected = false;
                                      });
                                    },
                                    child: Row(
                                      children: [
                                        Icon(
                                          Icons.circle_outlined,
                                          color: Colors.black,
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 10, vertical: 10),
                                          child: Text(
                                            'ListView',
                                            style: TextStyle(
                                                color: Color.fromARGB(
                                                    0xFF, 0x55, 0x55, 0x55)),
                                          ),
                                        ),
                                      ],
                                    ),
                                    style: ButtonStyle(
                                      backgroundColor:
                                          MaterialStateProperty.all(
                                              isListViewSelected
                                                  ? Color.fromARGB(
                                                      0xFF, 0xDD, 0xE1, 0xE6)
                                                  : Colors.white),
                                    ),
                                  ),
                                  OutlinedButton(
                                    onPressed: () {
                                      setState(() {
                                        isListViewSelected = false;
                                        isGridViewSelected = false;
                                        isMapViewSelected = true;
                                      });
                                    },
                                    child: Row(
                                      children: [
                                        Icon(
                                          Icons.circle_outlined,
                                          color: Colors.black,
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 10, vertical: 10),
                                          child: Text(
                                            'MapView',
                                            style: TextStyle(
                                                color: Color.fromARGB(
                                                    0xFF, 0x55, 0x55, 0x55)),
                                          ),
                                        ),
                                      ],
                                    ),
                                    style: ButtonStyle(
                                      backgroundColor:
                                          MaterialStateProperty.all(
                                              isMapViewSelected
                                                  ? Color.fromARGB(
                                                  0xFF, 0xDD, 0xE1, 0xE6)
                                                  : Colors.white),
                                    ),
                                  ),OutlinedButton(
                                    onPressed: () {
                                      setState(() {
                                        isListViewSelected = false;
                                        isGridViewSelected = true;
                                        isMapViewSelected = false;
                                      });
                                    },
                                    child: Row(
                                      children: [
                                        Icon(
                                          Icons.circle_outlined,
                                          color: Colors.black,
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 10, vertical: 10),
                                          child: Text(
                                            'GridView',
                                            style: TextStyle(
                                                color: Color.fromARGB(
                                                    0xFF, 0x55, 0x55, 0x55)),
                                          ),
                                        ),
                                      ],
                                    ),
                                    style: ButtonStyle(
                                      backgroundColor:
                                      MaterialStateProperty.all(
                                          isGridViewSelected
                                              ? Color.fromARGB(
                                              0xFF, 0xDD, 0xE1, 0xE6)
                                              : Colors.white),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),

                          Spacer(),
                          OutlinedButton(
                              onPressed: () {
                                // Push the MainFilterUI route to the navigator stack
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => FilterUI()),
                                );
                              },
                              child: Text(
                                "Filter Innovation-Hubs",
                                style: TextStyle(color: Colors.black),
                              ))
                        ],
                      ),
                    ),
                    // Display either ListView or MapView based on selection
                  ],
                ),
              ),
            ),
            Expanded(
              child: isListViewSelected
                  ? InnoHubListWidget()
                  : (isMapViewSelected ? InnoMap() : InnoHubGridWidget()), // Falls weder ListView noch MapView ausgewählt ist, wird ein leeres Container-Widget verwendet
            ),
          ],
        ),
      ),
    );
  }
}
