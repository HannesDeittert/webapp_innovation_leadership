import 'package:auto_size_text/auto_size_text.dart';
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

  Future<Widget> _loadImage(width,height,path) async {
    try {
      final ref = firebase_storage.FirebaseStorage.instance.ref(path);
      final url = await ref.getDownloadURL();

      // Lade das Bild von der URL
      final imageWidget = Image.network(url);

      // Du kannst die Größe des Bildes anpassen, indem du eine `Container`-Umgebung verwendest
      return ClipRRect(
        borderRadius: BorderRadius.all(Radius.circular(10)),
        child: Image.network(
          url,
          height: height,
          width: width,
          fit: BoxFit.cover,
        ),
      );
    } catch (e) {
      print('Fehler beim Laden des Bildes: $e');
      // Hier könntest du ein Standardbild zurückgeben oder eine Fehlermeldung anzeigen
      return Image.asset('assets/placeholder_image.jpg'); // Beispiel für ein Standardbild
    }
  }

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
                            "innohub",
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
              height: 50,
            ),
            Expanded(
              child: Center(
                child: Consumer<EventProvider>(
                  builder: (context, provider2, child) {
                    // Liste der gefilterten Hubs abrufen
                    List<HubEvents> allEvents = provider2.allHubevents;
                    print("Inside Events; $allEvents");
                    List<HubEvents> filteredEvents = provider2.filteredEvents;
                    print("Events: $filteredEvents");

                    return SingleChildScrollView(
                      child: Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                    color: tWhite,
                                    borderRadius: BorderRadius.all(Radius.circular(27.5)),
                                  ),
                                  height: 55,
                                  width: MediaQuery.of(context).size.width * (689 / 1512),
                                  child: Row(
                                    children: [
                                      GestureDetector(
                                        child: Row(
                                          children: [
                                            Icon(Icons.search_sharp),
                                            SizedBox(
                                              width: 5.5,
                                            ),
                                            Text(
                                              "Search for keywords",
                                              style: TextStyle(
                                                fontWeight: FontWeight.w400,
                                                fontSize: 16,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Spacer(),
                                      Container(
                                        width: 44,
                                        height: 44,
                                        decoration: BoxDecoration(
                                          color: tBlue,
                                          borderRadius: BorderRadius.all(Radius.circular(22)),
                                        ),
                                        child: Icon(
                                          Icons.add,
                                          color: tWhite,
                                          size: 14.0,
                                        ),
                                      ),
                                      SizedBox(
                                        width: 5.5,
                                      )
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 32,
                            ),
                            Container(
                              width: MediaQuery.of(context).size.width * (1384/1512),

                              child: Row(
                                children: [
                                  Text("2 Open Threads",style: TextStyle(
                                    fontSize: 32,
                                    fontWeight: FontWeight.w700
                                  ),),
                                  Spacer()
                                ],
                              ),
                            ),

                            SizedBox(
                              height: 32,
                            ),
                        Column(
                                children: [
                                  Container(
                                    width: MediaQuery.of(context).size.width * (1384/1512),
                                    decoration: BoxDecoration(
                                      color: tWhite,
                                      borderRadius: BorderRadius.all(Radius.circular(30))
                                    ),
                                    child: Padding(
                                      padding: EdgeInsets.all(32),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text("Looking for people to participate in Hackathon",style: TextStyle(
                                            fontWeight: FontWeight.w700,
                                            fontSize: 24
                                          ),),
                                          SizedBox(
                                            height: 32,
                                          ),
                                          Container(
                                            width: MediaQuery.of(context).size.width * (1384/1512) -64,
                                            child: Column(
                                              children: [
                                                Container(
                                                  width: MediaQuery.of(context).size.width * (1384/1512) -64,
                                                  child: Row(
                                                    children: [
                                                      FutureBuilder(
                                                        future: _loadImage(MediaQuery.of(context).size.height * (64 / 1032),MediaQuery.of(context).size.height * (62 / 1032),"Images/Profile/Rectangle 32.png"),
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
                                                      SizedBox(
                                                        width: 5,
                                                      ),
                                                      Column(
                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                        children: [
                                                          Text("Katharina Müller",style: TextStyle(
                                                            fontSize: 16,
                                                            fontWeight: FontWeight.w500
                                                          ),),
                                                          Text("6h ago",style: TextStyle(
                                                            color: Color(0xFFC3C3C3),
                                                            fontSize: 16
                                                          ),)
                                                        ],
                                                      ),
                                                      Spacer(),
                                                      Container(
                                                        height: 45,
                                                        decoration: BoxDecoration(
                                                          color: Color(0xFFD1E7FF),
                                                          border: Border.all(
                                                            width: 2,
                                                            color: tBlue,
                                                          ),
                                                          borderRadius: BorderRadius.circular(22.5 ),
                                                        ),
                                                        child: Padding(
                                                          padding: const EdgeInsets.symmetric(horizontal: 10),
                                                          child: Center(
                                                            child: Text(

                                                              "Hackathon",

                                                              style: TextStyle(
                                                                fontSize: 20,
                                                                fontWeight: FontWeight.w600,
                                                                color: tBlue,
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                      SizedBox(
                                                        width: 10,
                                                      ),
                                                      Container(
                                                        height: 45,
                                                        decoration: BoxDecoration(
                                                          color: Color(0xFFD1E7FF),
                                                          border: Border.all(
                                                            width: 2,
                                                            color: tBlue,
                                                          ),
                                                          borderRadius: BorderRadius.circular(22.5 ),
                                                        ),
                                                        child: Padding(
                                                          padding: const EdgeInsets.symmetric(horizontal: 10),
                                                          child: Center(
                                                              child: Text(

                                                                "Development",

                                                                style: TextStyle(
                                                                  fontSize: 20,
                                                                  fontWeight: FontWeight.w600,
                                                                  color: tBlue,
                                                                ),
                                                              ),
                                                            ),
                                                        ),
                                                        ),
                                                    ],
                                                  ),
                                                ),
                                                SizedBox(
                                                  height: 32,
                                                ),
                                                Container(
                                                  width: MediaQuery.of(context).size.width * (1384/1512) -64,
                                                    child: AutoSizeText("Hey folks,\nHope you're all doing well! So, the next hackathon is just around the corner, and I'm on the lookout for some fellow students to team up with. If you're passionate about coding, whether it's Python, JavaScript, or any language, and if you have a creative streak, be it in design or UX, I want you on board 🤝 Just drop me a message or reply in this thread. Looking forward to hearing from you all! 🎉",style: TextStyle(
                                                      fontSize: 20,
                                                      fontWeight: FontWeight.w400
                                                    ),
                                                    maxLines: 4,
                                                    ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          SizedBox(
                                            height: 32,
                                          ),
                                          Container(
                                            width: MediaQuery.of(context).size.width * (1384/1512) -64,
                                            child: Row(
                                              children: [
                                                Container(
                                                  height: 45,
                                                  width: 45,
                                                  decoration: BoxDecoration(
                                                      color: Color(0xFFF6F6F6),
                                                      borderRadius: BorderRadius.circular(22.5)
                                                  ),
                                                  child: Icon(
                                                    Icons.bookmark,
                                                    color: Color(0xFFDDDDDD),
                                                  ),
                                                ),
                                                SizedBox(
                                                  width: 10,
                                                ),
                                                Container(
                                                  height: 45,
                                                  width: 165,
                                                  decoration: BoxDecoration(
                                                      color: Color(0xFFF6F6F6),
                                                      borderRadius: BorderRadius.circular(22.5)
                                                  ),
                                                  child: Center(
                                                    child: Row(
                                                      children: [
                                                        Spacer(),
                                                        Icon(
                                                          Icons.chat_bubble,
                                                          color: Color(0xFFDDDDDD),
                                                        ),
                                                        Spacer(),
                                                        Text("Add Response"),
                                                        Spacer(),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                                Spacer(),
                                                Text("0 responses")
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 35,
                                  ),
                                  Container(
                                    width: MediaQuery.of(context).size.width * (1384/1512),
                                    decoration: BoxDecoration(
                                        color: tWhite,
                                        borderRadius: BorderRadius.all(Radius.circular(30))
                                    ),
                                    child: Padding(
                                      padding: EdgeInsets.all(32),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text("New in the City - Let's Explore Innovation Together!",style: TextStyle(
                                              fontWeight: FontWeight.w700,
                                              fontSize: 24
                                          ),),
                                          SizedBox(
                                            height: 32,
                                          ),
                                          Container(
                                            width: MediaQuery.of(context).size.width * (1384/1512) -64,
                                            child: Column(
                                              children: [
                                                Container(
                                                  width: MediaQuery.of(context).size.width * (1384/1512) -64,
                                                  child: Row(
                                                    children: [
                                                      FutureBuilder(
                                                        future: _loadImage(MediaQuery.of(context).size.height * (64 / 1032),MediaQuery.of(context).size.height * (62 / 1032),"Images/Profile/Rectangle 32 (1).png"),
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
                                                      SizedBox(
                                                        width: 5,
                                                      ),
                                                      Column(
                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                        children: [
                                                          Text("Oleksii Shwez",style: TextStyle(
                                                              fontSize: 16,
                                                              fontWeight: FontWeight.w500
                                                          ),),
                                                          Text("2d ago",style: TextStyle(
                                                              color: Color(0xFFC3C3C3),
                                                              fontSize: 16
                                                          ),)
                                                        ],
                                                      ),
                                                      Spacer(),
                                                      Container(
                                                        height: 45,
                                                        decoration: BoxDecoration(
                                                          color: Color(0xFFD1E7FF),
                                                          border: Border.all(
                                                            width: 2,
                                                            color: tBlue,
                                                          ),
                                                          borderRadius: BorderRadius.circular(22.5 ),
                                                        ),
                                                        child: Padding(
                                                          padding: const EdgeInsets.symmetric(horizontal: 10),
                                                          child: Center(
                                                            child: Text(

                                                              "Get Together",

                                                              style: TextStyle(
                                                                fontSize: 20,
                                                                fontWeight: FontWeight.w600,
                                                                color: tBlue,
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      ),

                                                    ],
                                                  ),
                                                ),
                                                SizedBox(
                                                  height: 32,
                                                ),
                                                Container(
                                                  width: MediaQuery.of(context).size.width * (1384/1512) -64,
                                                  child: AutoSizeText("Hey fellow students 👋 I'm fresh in town and eager to dive into the local innovation scene. If you're as excited as I am to explore innovation hubs and events, let's team up for this adventure! Drop a reply or slide into my DMs if you're up for discovering the tech side of our new city together.",style: TextStyle(
                                                      fontSize: 20,
                                                      fontWeight: FontWeight.w400
                                                  ),
                                                    maxLines: 4,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          SizedBox(
                                            height: 32,
                                          ),
                                          Container(
                                            width: MediaQuery.of(context).size.width * (1384/1512) -64,
                                            child: Row(
                                              children: [
                                                Container(
                                                  height: 45,
                                                  width: 45,
                                                  decoration: BoxDecoration(
                                                      color: Color(0xFFF6F6F6),
                                                      borderRadius: BorderRadius.circular(22.5)
                                                  ),
                                                  child: Icon(
                                                    Icons.bookmark,
                                                    color: tBlue,
                                                  ),
                                                ),
                                                SizedBox(
                                                  width: 10,
                                                ),
                                                Container(
                                                  height: 45,
                                                  width: 165,
                                                  decoration: BoxDecoration(
                                                      color: Color(0xFFF6F6F6),
                                                      borderRadius: BorderRadius.circular(22.5)
                                                  ),
                                                  child: Center(
                                                    child: Row(
                                                      children: [
                                                        Spacer(),
                                                        Icon(
                                                          Icons.chat_bubble,
                                                          color: Color(0xFFDDDDDD),
                                                        ),
                                                        Spacer(),
                                                        Text("Add Response"),
                                                        Spacer(),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                                Spacer(),
                                                Text("2 responses")
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            )

          ]),
    );
  }
}