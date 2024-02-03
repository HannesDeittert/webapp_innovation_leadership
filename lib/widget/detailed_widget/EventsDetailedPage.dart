import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:webapp_innovation_leadership/InnovationHubs.dart';
import 'package:webapp_innovation_leadership/datamanager/DetailedHubInfo.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:webapp_innovation_leadership/datamanager/InnovationHub.dart';
import 'package:webapp_innovation_leadership/datamanager/Work.dart';
import '../../Constants/Colors.dart';
import '../../Events.dart';
import '../../Homepage.dart';
import '../../InnovationGuide.dart';
import '../../datamanager/DetailedHubInfoProvider.dart';
import '../../datamanager/EventProvieder.dart';
import '../../datamanager/Events.dart';
import '../../datamanager/InnovationHubProvider.dart';
import '../../datamanager/WorkProvider.dart';
import '../../login/login_screen.dart';
import '../innovationhubdetailpage.dart';


class EventsDetailedPage extends StatelessWidget {


  EventsDetailedPage(this.Event, this.Range, this.Date, this.Hub);

  final HubEvents Event;
  late InnovationHub Hub;
  final String Range;
  final String Date;
  final String imagePath = 'Images/FAU_INNOVATION_LOGO.png';
  bool isEventSelected = false;
  bool isWorkSelected = false;
  bool isAboutViewSelected = true;
  bool isContactSelected = false;
  bool isHomeViewSelected = false;
  bool isHubViewSelected = false;
  bool isEventViewSelected = true;
  bool isGuideViewSelected = false;
  bool isCommunityViewSelected = false;
  bool isDetailedViewSelected = false;


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


  Future<ImageProvider> _loadProfileImage(String path) async {
    try {
      final ref = firebase_storage.FirebaseStorage.instance.ref(path);
      final url = await ref.getDownloadURL();
      return NetworkImage(url);
    } catch (e) {
      print('Fehler beim Laden des Profilbildes: $e');
      return AssetImage('assets/placeholder_image.jpg');
    }
  }

  @override
  Widget build(BuildContext context) {
    DetailedHubInfoProvider detailedHubInfoProvider =
    Provider.of<DetailedHubInfoProvider>(context, listen: false);
    String Cost = "Paid";
    String Name = Hub.name;
    String Orga = "Organized by $Name";
    Uri Link = Uri(
        scheme: 'https',
        path: Event.link,
    );

    if(Event.free == true){
      Cost = "Free";
    }
    return Scaffold(
      backgroundColor: tBackground,
      body: Container(
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                  height: MediaQuery.of(context).size.height * 0.0155
              ),
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
                            Text("innohub",style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600
                            ),)
                          ],
                        ),
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
                                      builder: (context) => LoginScreen()),
                                );
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
                      SizedBox(
                        width: 0,
                      )
                    ],
                  ),
                ),
              ),
              SizedBox(
                  height: MediaQuery.of(context).size.height * 0.0155
              ),
              Expanded(
                  child: SingleChildScrollView(
                    child: Container(
                      color: tWhite,
                      child: Column(
                        children: [
                          Container(
                            color: tWhite,
                            child: Padding(
                              padding: EdgeInsets.symmetric(vertical:  MediaQuery.of(context).size.height * 0.0155,horizontal:MediaQuery.of(context).size.width *(66/1512) ),
                              child: GestureDetector(
                                onTap: (){
                                  Navigator.pop(context);
                                },
                                child: Row(
                                  children: [
                                    Icon(Icons.arrow_back,
                                      color: tPrimaryColorText,),
                                    Text("Back to overview",
                                      style: TextStyle(
                                          fontSize: 16,
                                          color: tPrimaryColorText
                                      ),
                                    ),
                                    Spacer(),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          Stack(
                            children: [
                              FutureBuilder(
                                future: _loadProfileImage(Event.eventImagePath),
                                builder: (context, snapshot) {
                                  if (snapshot.connectionState ==
                                      ConnectionState.done) {
                                    return ClipRRect(
                                      borderRadius: BorderRadius.vertical(top: Radius.circular(15),bottom:Radius.circular(15) ),
                                      child: Image(
                                        height: MediaQuery.of(context).size.width *(1380/1512)*(317/1380),
                                        width: MediaQuery.of(context).size.width *(1380/1512),
                                        image: snapshot.data as ImageProvider,
                                        fit: BoxFit.cover,
                                      ),
                                    );
                                  } else {
                                    return Container();
                                  }
                                },
                              ),
                              Positioned(
                                  bottom: 10,
                                  left: 10,
                                  child: Container(
                                    width: 68,
                                    height: 32,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(5),
                                        color: tWhiteop
                                    ),
                                    child: Center(
                                      child: Text(
                                          Cost,
                                          style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w400,
                                              color: tWritingGrey
                                          ),
                                          textAlign: TextAlign.center
                                      ),
                                    ),
                                  ))
                            ],
                          ),
                          SizedBox(
                              height: MediaQuery.of(context).size.height * 0.03
                          ),
                          Row(
                            children: [
                            SizedBox(
                               width: MediaQuery.of(context).size.width *(66/1512),
                            ),
                            Text(Event.title,
                              style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontSize: 40
                              ),),
                            Spacer(),
                            GestureDetector(
                              onTap: ()async {
                            _launchInBrowser(Link);
                            },
                              child: Container(
                                decoration: BoxDecoration(
                                    color: Colors.blue,
                                    borderRadius: BorderRadius.circular((MediaQuery.of(context).size.height * (60 / 982))/2,)
                                ),
                                child: Padding(
                                  padding: EdgeInsets.symmetric(vertical: 10,horizontal: 40),
                                  child: Center(
                                    child: Text(
                                      'Attend Event',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              width: MediaQuery.of(context).size.width *(66/1512),
                            ),
                          ],),
                          SizedBox(
                            height: 8,
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width *(66/1512)),
                            child: AutoSizeText(
                              Event.description,
                              style: TextStyle(fontSize: 32,fontWeight: FontWeight.w400),
                              maxLines: 4,
                            ),
                          ),
                          SizedBox(
                              height: MediaQuery.of(context).size.height * 0.03
                          ),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                width: MediaQuery.of(context).size.width * (66 / 1512),
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Icon(Icons.location_on_sharp),
                                    ],
                                  ),
                                  SizedBox(width: 8), // Platz zwischen Icon und Text
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "Date & Time",
                                        style: TextStyle(fontSize: 24, fontWeight: FontWeight.w500),
                                      ),
                                      SizedBox(height: 2),
                                      Text(
                                        Date,
                                        style: TextStyle(fontSize: 24, fontWeight: FontWeight.w400),
                                      ),
                                      Text(
                                        Range,
                                        style: TextStyle(fontSize: 24, fontWeight: FontWeight.w400),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              Container(
                                width: 1, // Breite des Trenners
                                height: 140, // Höhe des Trenners
                                color: Color.fromARGB(255, 	186, 	186, 	186), // Farbe des Trenners
                                margin: EdgeInsets.symmetric(horizontal: 16), // Abstand zu den umliegenden Widgets
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Icon(Icons.location_on_sharp),
                                    ],
                                  ),
                                  SizedBox(width: 8), // Platz zwischen Icon und Text
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "Location",
                                        style: TextStyle(fontSize: 24, fontWeight: FontWeight.w500),
                                      ),
                                      SizedBox(height: 2),
                                      Text(
                                        Event.Location,
                                        style: TextStyle(fontSize: 24, fontWeight: FontWeight.w400),
                                      ),
                                      Text(
                                        Event.Street,
                                        style: TextStyle(fontSize: 24, fontWeight: FontWeight.w400),
                                      ),
                                      Text(
                                        Event.City,
                                        style: TextStyle(fontSize: 24, fontWeight: FontWeight.w400),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              Spacer(),
                              SizedBox(
                                width: MediaQuery.of(context).size.width * (66 / 1512),
                              ),
                            ],
                          ),

                          SizedBox(
                              height: MediaQuery.of(context).size.height * 0.03
                          ),
                          if(Hub.code.isNotEmpty)
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                SizedBox(
                                  width: MediaQuery.of(context).size.width *(66/1512),
                                ),

                                Container(
                                  height: MediaQuery.of(context).size.width *(500/1512)*(43/125),
                                  width: MediaQuery.of(context).size.width *(500/1512),
                                  decoration: BoxDecoration(
                                    color: tWhite,
                                    boxShadow: [
                                      BoxShadow(
                                        color: Color(0xFFD5D5D5).withOpacity(0.25), // Farbe mit Opazität
                                        offset: Offset(0, 4), // Versatz in der horizontalen und vertikalen Richtung
                                        blurRadius: 20, // Radius des Schatten
                                        spreadRadius: 0, // Verbreitung des Schattens
                                      ),
                                    ],
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding: EdgeInsets.symmetric(vertical: 36,horizontal: MediaQuery.of(context).size.width *(50/1512)),
                                        child: Row(
                                            mainAxisAlignment: MainAxisAlignment.start,
                                            children: [
                                              FutureBuilder(
                                                future: _loadProfileImage(Hub.profileImagePath),
                                                builder: (context, snapshot) {
                                                  if (snapshot.connectionState ==
                                                      ConnectionState.done) {
                                                    return ClipRRect(
                                                      borderRadius: BorderRadius.vertical(top: Radius.circular(MediaQuery.of(context).size.width *(100/1512)*0.5),bottom:Radius.circular(MediaQuery.of(context).size.width *(100/1512)*0.5) ),
                                                      child: Image(
                                                        height: MediaQuery.of(context).size.width *(100/1512),
                                                        width: MediaQuery.of(context).size.width *(100/1512),
                                                        image: snapshot.data as ImageProvider,
                                                        fit: BoxFit.cover,
                                                      ),
                                                    );
                                                  } else {
                                                    return Container();
                                                  }
                                                },
                                              ),
                                              SizedBox(
                                                  width: 20
                                              ),
                                              Container(
                                                width: MediaQuery.of(context).size.width *(500/1512)-20-MediaQuery.of(context).size.width *(200/1512),
                                                child: Column(
                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    Row(
                                                      children: [
                                                        Expanded(
                                                          child: Text(Orga,
                                                            style: TextStyle(
                                                                fontWeight: FontWeight.w500,
                                                                fontSize: 24
                                                            ),
                                                            overflow: TextOverflow.ellipsis,),
                                                        ),
                                                      ],
                                                    ),
                                                    GestureDetector(
                                                      onTap: () async {
                                                        // Den DetailedHubInfoProvider vom Kontext abrufen
                                                        DetailedHubInfoProvider detailedHubInfoProvider =
                                                        Provider.of<DetailedHubInfoProvider>(context, listen: false);
                                                        InnovationHubProvider provider =
                                                        Provider.of<InnovationHubProvider>(context, listen: false);
                                                        EventProvider provider3 = Provider.of<EventProvider>(context, listen:  false);
                                                        WorkProvider provider4 = Provider.of<WorkProvider>(context, listen:  false);
                                                        // _detailedHubInfo über die loadDetailedHubInfo-Methode initialisieren
                                                        await detailedHubInfoProvider.getHubInfoByCode(Hub.code,Hub.filtered_chips);
                                                        await detailedHubInfoProvider.getMenu();
                                                        await provider3.loadAllEvents();
                                                        await provider3.getEventListFromUidList(detailedHubInfoProvider.detailedInnovationHub.events);
                                                        await provider4.loadAllHubworks();
                                                        await provider4.getHubworksListFromUidList(detailedHubInfoProvider.detailedInnovationHub.work);
                                                        print(detailedHubInfoProvider.detailedInnovationHub);
                                                        provider.calculate_recomendations(Hub);
                                                        print(provider.recomendations);
                                                        // Zur Detailseite navigieren
                                                        Navigator.push(
                                                          context,
                                                          MaterialPageRoute(
                                                            builder: (context) => InnovationHubDetailPage(stringList: Hub.filtered_chips,),
                                                          ),
                                                        );
                                                      },
                                                      child: Text("Open Company Page", style: TextStyle(
                                                          fontWeight: FontWeight.w400,
                                                          fontSize: 20,
                                                          decoration: TextDecoration.underline,
                                                          decorationColor: Color.fromARGB(255, 	186, 	186, 	186),
                                                          color: Color.fromARGB(255, 	186, 	186, 	186)
                                                      ),),
                                                    )
                                                  ],
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                      Spacer()
                                    ],
                                  ),
                                ),

                                Spacer(),
                                SizedBox(
                                  width: MediaQuery.of(context).size.width *(66/1512),
                                ),
                              ],
                            ),
                          SizedBox(
                              height: MediaQuery.of(context).size.height * 0.0155
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
Future<void> _launchInBrowser(Uri url) async {
  if (!await launchUrl(
    url,
    mode: LaunchMode.externalApplication,
  )) {
    throw Exception('Could not launch $url');
  }
}