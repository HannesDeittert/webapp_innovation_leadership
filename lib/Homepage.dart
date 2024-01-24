import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:side_sheet/side_sheet.dart';
import 'package:webapp_innovation_leadership/Events.dart';
import 'package:webapp_innovation_leadership/InnovationGuide.dart';
import 'package:webapp_innovation_leadership/datamanager/PDFRefProvider.dart';
import 'package:webapp_innovation_leadership/datamanager/QuestionProvider.dart';
import 'package:webapp_innovation_leadership/home.dart';
import 'package:webapp_innovation_leadership/widget/FilterWidgets/mainFilterUI.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:webapp_innovation_leadership/widget/PopUpContent.dart';
import 'CommunityPages/Community.dart';
import 'InnovationHubs.dart';
import 'constants/colors.dart';
import 'datamanager/DetailedHubInfoProvider.dart';
import 'datamanager/EventProvieder.dart';
import 'datamanager/InnovationHubProvider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'datamanager/WorkProvider.dart';
import 'login/login_screen.dart';


class MyHomePage extends StatefulWidget {
  @override
  State<MyHomePage> createState() => _HomePage();
}

class _HomePage extends State<MyHomePage> {
  final InnovationHubProvider provider = InnovationHubProvider();
  //final PDFRefProvider provider2 = PDFRefProvider();
  final EventProvider provider3 = EventProvider();
  bool isHomeViewSelected = true;
  bool isHubViewSelected = false;
  bool isEventViewSelected = false;
  bool isGuideViewSelected = false;
  bool isCommunityViewSelected = false;
  String selectedLocation = 'Fürth';
  List<String> locations = ['Fürth', 'Erlangen', 'Nürnberg'];


  @override
  void initState() {
    provider.loadInnovationHubsFromFirestore();
    //provider2.loadPDFRefsFromFirestore();
    provider3.loadAllEvents().then((_) {
      provider3.createFilterdEventList(provider3.allHubevents);
    });
  }
  final String imagePath = 'Images/FAU_INNOVATION_LOGO.png';

  Future<Widget> _loadLeadingImage(width,height) async {
    try {
      final ref = firebase_storage.FirebaseStorage.instance.ref(imagePath);
      final url = await ref.getDownloadURL();

      // Lade das Bild von der URL
      final imageWidget = Image.network(url);

      // Du kannst die Größe des Bildes anpassen, indem du eine `Container`-Umgebung verwendest
      return Container(
        width: width*0.03248,  // Ändere dies nach Bedarf
        height: height*0.05,  // Ändere dies nach Bedarf
        child: imageWidget,
      );
    } catch (e) {
      print('Fehler beim Laden des Bildes: $e');
      // Hier könntest du ein Standardbild zurückgeben oder eine Fehlermeldung anzeigen
      return Image.asset('assets/placeholder_image.jpg'); // Beispiel für ein Standardbild
    }
  }
  Future<Widget> _loadImage(width,height,path) async {
    try {
      final ref = firebase_storage.FirebaseStorage.instance.ref(path);
      final url = await ref.getDownloadURL();

      // Lade das Bild von der URL
      final imageWidget = Image.network(url);

      // Du kannst die Größe des Bildes anpassen, indem du eine `Container`-Umgebung verwendest
      return Container(
        width: width,  // Ändere dies nach Bedarf
        height: height,  // Ändere dies nach Bedarf
        child: imageWidget,
      );
    } catch (e) {
      print('Fehler beim Laden des Bildes: $e');
      // Hier könntest du ein Standardbild zurückgeben oder eine Fehlermeldung anzeigen
      return Image.asset('assets/placeholder_image.jpg'); // Beispiel für ein Standardbild
    }
  }
  Future<Widget> _loadExpandedImage(path) async {
    try {
      final ref = firebase_storage.FirebaseStorage.instance.ref(path);
      final url = await ref.getDownloadURL();

      // Lade das Bild von der URL
      final imageWidget = Image.network(url);

      // Du kannst die Größe des Bildes anpassen, indem du eine `Container`-Umgebung verwendest
      return Expanded(// Ändere dies nach Bedarf
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
      backgroundColor: tBackground,
      body: Column(
        children: [
          SizedBox(height: MediaQuery.of(context).size.height*0.031,),
          Container(
            decoration: BoxDecoration(
                color: tBackground,
                border: Border(
                  bottom: BorderSide(
                      width: 1,
                      color:  tBackground),
                )
            ),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width/30,vertical: 0.0 ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  
                  Row(
                    children: [
                      FutureBuilder(
                        future: _loadLeadingImage(MediaQuery.of(context).size.width,MediaQuery.of(context).size.height),
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
                      Text("fau innohub",style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600
                      ),)
                    ],
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width*0.455,
                    height: MediaQuery.of(context).size.height*0.062,
                    decoration: BoxDecoration(
                      color: tWhite,
                      borderRadius: BorderRadius.circular(MediaQuery.of(context).size.height*0.031,)
                    ),
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
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => GuideHome()),
                            );
                          },
                          child: Text(
                            "Innovation Guide",
                            style: TextStyle(
                                fontWeight: isGuideViewSelected ?FontWeight.w700: FontWeight.w500,
                                fontSize: 16
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => Community()),
                            );
                            /*Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => LoginScreen()),
                            );*/
                          },
                          child: Text(
                            "Community",
                            style: TextStyle(
                                fontWeight: isCommunityViewSelected ?FontWeight.w700: FontWeight.w500,
                                fontSize: 16
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Row(
                    children: [
                      Icon(Icons.location_on_outlined,color: Colors.blue,),
                      SizedBox(width: 8.0),

                      DropdownButton<String>(
                        value: selectedLocation,
                        icon: Icon(
                          Icons.arrow_drop_down,
                          color: Colors.blue,
                        ),
                        iconSize: 24,
                        elevation: 16,
                        style: TextStyle(color: Colors.blue),
                        underline: Container(
                          height: 2,
                          color: tBackground,
                        ),
                        onChanged: (String? newValue) {
                          setState(() {
                            selectedLocation = newValue!;
                          });
                        },
                        items: locations.map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                      ),
                    ],
                  )
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
                      SizedBox(height: MediaQuery.of(context).size.height*0.04),
                      Container(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                              "Discover, Connect, Innovate",
                              style: TextStyle(
                                fontSize: 48,
                                fontWeight: FontWeight.w800
                              ),
                            ),
                            Text(
                              'Welcome to your All-In-One innovation ecosystem hub at FAU',
                              style: TextStyle(fontSize: 32,fontWeight: FontWeight.w400),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: MediaQuery.of(context).size.height*0.031),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          GestureDetector(
                            onTap: (){
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => InnovationHubs()),
                              );
                            },
                            child: Container(
                              width: MediaQuery.of(context).size.width*0.458,
                              height: MediaQuery.of(context).size.height*0.31975,
                              decoration: BoxDecoration(
                                  color: tWhite,
                                  borderRadius: BorderRadius.circular(30)
                              ),
                              child: Padding(
                                padding: EdgeInsets.all(MediaQuery.of(context).size.width*0.0205),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          children: [
                                            Text("Innovation hubs",style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w500
                                            ),),
                                            Text("Discover our diverse innovation locations",style: TextStyle(
                                                fontSize: 24,
                                                fontWeight: FontWeight.w500
                                            ),),
                                          ],
                                        ),
                                        GestureDetector(
                                          onTap: (){
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) => InnovationHubs()),
                                            );
                                          },
                                          child: Container(
                                            width: MediaQuery.of(context).size.height*0.059,
                                            height: MediaQuery.of(context).size.height*0.059,
                                            decoration: BoxDecoration(
                                                color: tBackground,
                                                borderRadius: BorderRadius.circular(MediaQuery.of(context).size.height*0.0295)
                                            ),
                                            child: Transform.rotate(
                                                angle: -45 * 0.0174533,
                                              child: Icon(
                                                Icons.arrow_forward,
                                              ),)
                                          ),
                                        )
                                      ],
                                    ),
                                    SizedBox(
                                      height: MediaQuery.of(context).size.width*0.0205,
                                    ),
                                    FutureBuilder(
                                      future:  _loadExpandedImage("Images/Fusch.PNG"),
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
                                  ],
                                ),
                              ),
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
                            child: Stack(
                              children: [
                                Container(
                                  width: MediaQuery.of(context).size.width*0.392,
                                  height: MediaQuery.of(context).size.height*0.31975,
                                  decoration: BoxDecoration(
                                      color: tWhite,
                                      borderRadius: BorderRadius.circular(30)
                                  ),
                                  child: Padding(
                                    padding: EdgeInsets.all(MediaQuery.of(context).size.width*0.0205),
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              mainAxisAlignment: MainAxisAlignment.start,
                                              children: [
                                                Text("Events",style: TextStyle(
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.w500
                                                ),),
                                                Text("Dynamic calendar of events",style: TextStyle(
                                                    fontSize: 24,
                                                    fontWeight: FontWeight.w500
                                                ),),
                                              ],
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
                                              child: Container(
                                                  width: MediaQuery.of(context).size.height*0.059,
                                                  height: MediaQuery.of(context).size.height*0.059,
                                                  decoration: BoxDecoration(
                                                      color: tBackground,
                                                      borderRadius: BorderRadius.circular(MediaQuery.of(context).size.height*0.0295)
                                                  ),
                                                  child: Transform.rotate(
                                                    angle: -45 * 0.0174533,
                                                    child: Icon(
                                                      Icons.arrow_forward,
                                                    ),)
                                              ),
                                            )
                                          ],
                                        ),
                                        SizedBox(
                                          height: MediaQuery.of(context).size.width*0.0205,
                                        ),
                                        Expanded(
                                          child: Container(
                                            width: MediaQuery.of(context).size.width*0.392*(400/594),
                                            child: FittedBox(
                                              fit: BoxFit.fitWidth,
                                              child: Text("Stay connected with our community through\na curated calendar of events, workshops,\nand conferences – where inspiration\ntransforms into action.",style: TextStyle(
                                                fontWeight: FontWeight.w400
                                              ),),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                Positioned(
                                  bottom: MediaQuery.of(context).size.height * (16 / 491),
                                  right: MediaQuery.of(context).size.width * (16 / 491),
                                  child: FutureBuilder(
                                    future: _loadImage(MediaQuery.of(context).size.height * (62 / 491),MediaQuery.of(context).size.height * (62 / 491),"Images/Storysetdump/3d-fluency-planner 1.png"),
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
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                      SizedBox(height: MediaQuery.of(context).size.height*0.031),

                      // Untere Reihe Container

                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          GestureDetector(
                            onTap: () async {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => GuideHome()),
                              );
                            },
                            child: Stack(
                              children: [
                                Container(
                                  width: MediaQuery.of(context).size.width*0.458,
                                  height: MediaQuery.of(context).size.height*0.31975,
                                  decoration: BoxDecoration(
                                      color: tWhite,
                                      borderRadius: BorderRadius.circular(30)
                                  ),
                                  child: Padding(
                                    padding: EdgeInsets.all(MediaQuery.of(context).size.width*0.0205),
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              mainAxisAlignment: MainAxisAlignment.start,
                                              children: [
                                                Text("Innovation Guide",style: TextStyle(
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.w500
                                                ),),
                                                Text("Navigate your personal path",style: TextStyle(
                                                    fontSize: 24,
                                                    fontWeight: FontWeight.w500
                                                ),),
                                              ],
                                            ),
                                            GestureDetector(
                                              onTap: () async {
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) => GuideHome()),
                                                );
                                              },
                                              child:
                                                Container(
                                                    width: MediaQuery.of(context).size.height*0.059,
                                                    height: MediaQuery.of(context).size.height*0.059,
                                                    decoration: BoxDecoration(
                                                        color: tBackground,
                                                        borderRadius: BorderRadius.circular(MediaQuery.of(context).size.height*0.0295)
                                                    ),
                                                    child: Transform.rotate(
                                                      angle: -45 * 0.0174533,
                                                      child: Icon(
                                                        Icons.arrow_forward,
                                                      ),)
                                                ),
                                            )
                                          ],
                                        ),
                                        SizedBox(
                                          height: MediaQuery.of(context).size.width*0.0205,
                                        ),
                                        Expanded(
                                          child: Container(
                                            width: MediaQuery.of(context).size.width*0.392*(400/594),
                                            child: FittedBox(
                                              fit: BoxFit.fitWidth,
                                              child: Text("Get your personalized PDF Guide with insider\ninsights, local tips, and essential information about\neach location.",style: TextStyle(
                                                  fontWeight: FontWeight.w400
                                              ),),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                Positioned(
                                  bottom: MediaQuery.of(context).size.height * (16 / 491),
                                  right: MediaQuery.of(context).size.width * (16 / 491),
                                  child: FutureBuilder(
                                    future: _loadImage(MediaQuery.of(context).size.height * (77 / 491),MediaQuery.of(context).size.height * (77 / 491),"Images/Storysetdump/3d-fluency-world-map 1.png"),
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
                                )
                              ],
                            ),
                          ),
                          GestureDetector(
                            onTap: () async {
                              DetailedHubInfoProvider detailedHubInfoProvider = Provider.of<DetailedHubInfoProvider>(context, listen: false);
                              EventProvider provider3 = Provider.of<EventProvider>(context, listen:  false);
                              WorkProvider provider4 = Provider.of<WorkProvider>(context, listen:  false);
                              // _detailedHubInfo über die loadDetailedHubInfo-Methode initialisieren
                              await provider3.loadAllEvents();
                              await provider4.loadAllHubworks();
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => Community()),
                              );
                              /*Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                builder: (context) => LoginScreen()),
                                                );*/
                            },
                            child: Stack(
                              children: [
                                Container(
                                  width: MediaQuery.of(context).size.width*0.392,
                                  height: MediaQuery.of(context).size.height*0.31975,
                                  decoration: BoxDecoration(
                                      color: tWhite,
                                      borderRadius: BorderRadius.circular(30)
                                  ),
                                  child: Padding(
                                    padding: EdgeInsets.all(MediaQuery.of(context).size.width*0.0205),
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              mainAxisAlignment: MainAxisAlignment.start,
                                              children: [
                                                Text("Community",style: TextStyle(
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.w500
                                                ),),
                                                Text("Innovate together",style: TextStyle(
                                                    fontSize: 24,
                                                    fontWeight: FontWeight.w500
                                                ),),
                                              ],
                                            ),
                                            GestureDetector(
                                              onTap: () async {
                                                DetailedHubInfoProvider detailedHubInfoProvider = Provider.of<DetailedHubInfoProvider>(context, listen: false);
                                                EventProvider provider3 = Provider.of<EventProvider>(context, listen:  false);
                                                WorkProvider provider4 = Provider.of<WorkProvider>(context, listen:  false);
                                                // _detailedHubInfo über die loadDetailedHubInfo-Methode initialisieren
                                                await provider3.loadAllEvents();
                                                await provider4.loadAllHubworks();
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) => Community()),
                                                );
                                                /*Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                builder: (context) => LoginScreen()),
                                                );*/
                                              },
                                              child:
                                              Container(
                                                  width: MediaQuery.of(context).size.height*0.059,
                                                  height: MediaQuery.of(context).size.height*0.059,
                                                  decoration: BoxDecoration(
                                                      color: tBackground,
                                                      borderRadius: BorderRadius.circular(MediaQuery.of(context).size.height*0.0295)
                                                  ),
                                                  child: Transform.rotate(
                                                    angle: -45 * 0.0174533,
                                                    child: Icon(
                                                      Icons.arrow_forward,
                                                    ),)
                                              ),
                                            )
                                          ],
                                        ),
                                        SizedBox(
                                          height: MediaQuery.of(context).size.width*0.0205,
                                        ),
                                        Expanded(
                                          child: Container(
                                            width: MediaQuery.of(context).size.width*0.392*(400/594),
                                            child: FittedBox(
                                              fit: BoxFit.fitWidth,
                                              child: Text("No more awkward feeling when go alone to the events.\nJoin our community, find your buddy, and explore\ninnovations and events together.",style: TextStyle(
                                                  fontWeight: FontWeight.w400
                                              ),),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                Positioned(
                                  bottom: MediaQuery.of(context).size.height * (16 / 491),
                                  right: MediaQuery.of(context).size.width * (16 / 600),
                                  child: FutureBuilder(
                                    future: _loadImage(MediaQuery.of(context).size.width * (839/ 7200),MediaQuery.of(context).size.height * 0.06024,"Images/Faces.PNG"),
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
                                ),
                              ],
                            ),
                          )
                        ],
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

