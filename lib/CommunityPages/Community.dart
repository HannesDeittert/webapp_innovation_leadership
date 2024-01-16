import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../Events.dart';
import '../Homepage.dart';
import '../InnovationHubs.dart';
import '../constants/colors.dart';
import '../datamanager/DetailedHubInfoProvider.dart';
import '../datamanager/EventProvieder.dart';
import '../datamanager/Events.dart';
import '../datamanager/InnovationHubProvider.dart';
import '../datamanager/WorkProvider.dart';

class Community extends StatefulWidget {
  const Community({Key? key}) : super(key: key);

  @override
  State<Community> createState() => _Community();
}

class _Community extends State<Community> {



  final InnovationHubProvider provider = InnovationHubProvider();

  final EventProvider provider3 = EventProvider();
  bool isHomeViewSelected = false;
  bool isHubViewSelected = false;
  bool isEventViewSelected = false;
  bool isGuideViewSelected = false;
  bool isCommunityViewSelected = true;
  bool isDetailedViewSelected = false;
  final String imagePath = 'Images/FAU_INNOVATION_LOGO.png';
  final String imageProfilePath = "Images/Storysetdump/casual-life-3d-profile-picture-of-man-in-green-shirt-and-orange-hat.png";


  Future<Widget> _loadLeadingImage(width, height) async {
    try {
      final ref = firebase_storage.FirebaseStorage.instance.ref(imagePath);
      final url = await ref.getDownloadURL();

      // Lade das Bild von der URL
      final imageWidget = Image.network(url);

      // Du kannst die Größe des Bildes anpassen, indem du eine `Container`-Umgebung verwendest
      return Container(
        width: width * 0.03248, // Ändere dies nach Bedarf
        height: height * 0.05, // Ändere dies nach Bedarf
        child: imageWidget,
      );
    } catch (e) {
      print('Fehler beim Laden des Bildes: $e');
      // Hier könntest du ein Standardbild zurückgeben oder eine Fehlermeldung anzeigen
      return Image.asset(
          'assets/placeholder_image.jpg'); // Beispiel für ein Standardbild
    }
  }
  Future<Widget> _loadProfileImage(width, height) async {
    try {
      final ref = firebase_storage.FirebaseStorage.instance.ref(imageProfilePath);
      final url = await ref.getDownloadURL();

      // Lade das Bild von der URL
      final imageWidget = Image.network(url);

      // Du kannst die Größe des Bildes anpassen, indem du eine `Container`-Umgebung verwendest
      return Container(
        width: width * 0.03248, // Ändere dies nach Bedarf
        height: height * 0.05, // Ändere dies nach Bedarf
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
    EventProvider provider3 = Provider.of<EventProvider>(context);
    List<HubEvents> fevents = provider3.filteredEvents;
    print("Hier$fevents");
    return Scaffold(
      backgroundColor: tBackground,
      body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.0155,
            ),
            Container(
              decoration: BoxDecoration(
                  color: tBackground,
                  border: Border(
                    bottom: BorderSide(width: 1, color: tBackground),
                  )),

              //ApoBar
              child: Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: MediaQuery.of(context).size.width / 30,
                    vertical: 0.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                      onTap: (){
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => MyHomePage(),
                          ),
                        );
                      },
                      child: Row(
                        children: [
                          FutureBuilder(
                            future: _loadLeadingImage(
                                MediaQuery.of(context).size.width,
                                MediaQuery.of(context).size.height),
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
                          Text(
                            "fau innohub",
                            style:
                            TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                          )
                        ],
                      ),
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width * 0.455,
                      height: MediaQuery.of(context).size.height * 0.062,
                      decoration: BoxDecoration(
                          color: tWhite,
                          borderRadius: BorderRadius.circular(
                            MediaQuery.of(context).size.height * 0.031,
                          )),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          GestureDetector(
                            onTap: (){
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => InnovationHubs(),
                                ),
                              );
                            },
                            child: Text(
                              "Innovation hubs",
                              style: TextStyle(
                                  fontWeight: isHubViewSelected
                                      ? FontWeight.w700
                                      : FontWeight.w500,
                                  fontSize: 16),
                            ),
                          ),
                          GestureDetector(
                            onTap: () async {
                              // Den DetailedHubInfoProvider vom Kontext abrufen
                              DetailedHubInfoProvider detailedHubInfoProvider = Provider.of<DetailedHubInfoProvider>(context, listen: false);
                              EventProvider provider3 = Provider.of<EventProvider>(context, listen:  false);
                              WorkProvider provider4 = Provider.of<WorkProvider>(context, listen:  false);
                              // _detailedHubInfo über die loadDetailedHubInfo-Methode initialisieren
                              await provider3.loadAllEvents();
                              await provider4.loadAllHubworks();
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => EventsHome()),
                              );
                            },
                            child: Text(
                              "Events",
                              style: TextStyle(
                                  fontWeight: isEventViewSelected
                                      ? FontWeight.w700
                                      : FontWeight.w500,
                                  fontSize: 16),
                            ),
                          ),
                          GestureDetector(
                            child: Text(
                              "Innovation Guide",
                              style: TextStyle(
                                  fontWeight: isGuideViewSelected
                                      ? FontWeight.w700
                                      : FontWeight.w500,
                                  fontSize: 16),
                            ),
                          ),
                          GestureDetector(
                            child: Text(
                              "Community",
                              style: TextStyle(
                                  fontWeight: isCommunityViewSelected
                                      ? FontWeight.w700
                                      : FontWeight.w500,
                                  fontSize: 16),
                            ),
                          ),
                        ],
                      ),
                    ),
                    GestureDetector(
                      onTap: (){
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => MyHomePage(),
                          ),
                        );
                      },
                      child:
                          FutureBuilder(
                            future: _loadProfileImage(
                                MediaQuery.of(context).size.width,
                                MediaQuery.of(context).size.height),
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
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(
              height: 8,
            ),
                Consumer<EventProvider>(
                  builder: (context, provider2, child) {
                    // Liste der gefilterten Hubs abrufen
                    List<HubEvents> allEvents = provider2.allHubevents;
                    print("Inside Events; $allEvents");
                    List<HubEvents> filteredEvents = provider2.filteredEvents;
                    print("Events: $filteredEvents");
                    return Expanded(
                      child:
                        Container(
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      ///ToDo: Add Logic to Request Group for an Event
                                    },
                                    child: Container(
                                      height: MediaQuery.of(context).size.height *
                                          (60 / 982),
                                      width: MediaQuery.of(context).size.width *
                                          (317 / 1512),
                                      decoration: BoxDecoration(
                                          color: Colors.blue,
                                          borderRadius: BorderRadius.circular(
                                            (MediaQuery.of(context).size.height *
                                                (60 / 982)) /
                                                2,
                                          )),
                                      child: Center(
                                        child: Text(
                                          'Add Group Request',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),

                                ],
                              )
                            ],
                          ),
                        )
                    );
                    },
            )
          ]),
    );
  }
}