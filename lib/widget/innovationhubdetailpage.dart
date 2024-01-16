import 'dart:html';

import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';
import 'package:side_sheet/side_sheet.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:webapp_innovation_leadership/datamanager/DetailedHubInfo.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:webapp_innovation_leadership/datamanager/Work.dart';

import '../Constants/Colors.dart';
import '../Events.dart';
import '../Homepage.dart';
import '../InnovationGuide.dart';
import '../InnovationHubs.dart';
import '../datamanager/DetailedHubInfoProvider.dart';

import '../datamanager/EventProvieder.dart';
import '../datamanager/Events.dart';
import '../datamanager/InnovationHub.dart';
import '../datamanager/InnovationHubProvider.dart';
import '../datamanager/WorkProvider.dart';
import '../login/login_screen.dart';
import 'EventListItem.dart';
import 'PopUpContent.dart';
import 'ResearchListItem.dart';
import 'detailed_widget/AboutWidget.dart';
import 'detailed_widget/ContactWidget.dart';
import 'detailed_widget/EventWidget.dart';
import 'detailed_widget/WorkWidget.dart';

class InnovationHubDetailPage extends StatefulWidget {

  final List<String> stringList;

  // Konstruktor, um die String-Liste zu übergeben
  InnovationHubDetailPage({required this.stringList});
  @override
  _InnovationHubDetailPageState createState() => _InnovationHubDetailPageState();
}

class _InnovationHubDetailPageState extends State<InnovationHubDetailPage> {
  final String imagePath = 'Images/FAU_INNOVATION_LOGO.png';
  bool isEventSelected = false;
  bool isWorkSelected = false;
  bool isAboutViewSelected = false;
  bool isContactSelected = false;
  bool isOverviewSelected = true;
  bool isHomeViewSelected = false;
  bool isHubViewSelected = true;
  bool isEventViewSelected = false;
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

  Map<String, String> loadContactMap(DetailedHubInfo info, LatLng coordinates) {
    Map<String, String> Contacts = {};

    if (info.website.isNotEmpty) {
      Contacts["Website"] = info.website;
    }

    if (info.tele_contact.isNotEmpty) {
      Contacts["TeleContact"] = info.tele_contact;
    }

    if (info.email_contact.isNotEmpty) {
      Contacts["EmailContact"] = info.email_contact;
    }

    // Hinzufügen der Koordinaten
    Contacts["Latitude"] = coordinates.latitude.toString();
    Contacts["Longitude"] = coordinates.longitude.toString();

    return Contacts;
  }

  @override
  Widget build(BuildContext context) {
    DetailedHubInfoProvider provider = Provider.of<DetailedHubInfoProvider>(context);
    InnovationHubProvider provider2 = Provider.of<InnovationHubProvider>(context);
    EventProvider provider3 = Provider.of<EventProvider>(context);

    WorkProvider provider4 = Provider.of<WorkProvider>(context);
    DetailedHubInfo info = provider.detailedInnovationHub;
    List<String> Chips = widget.stringList;
    print("Chips $Chips");
    List<HubEvents> fevents = provider3.filteredEvents;
    print("Hier$fevents");
    List<HubEvents> events = provider3.Hubevents;
    List<HubWork> Research = provider4.Hubworks;
    print(events);
    LatLng coordinates = provider2.innovationHubs.firstWhere((element) => element.code == info.code).coordinates;
    Map<String, String> Contacts = loadContactMap(info, coordinates);
    print(Contacts);
    List<String> menuItems = provider.Menu;
    List<InnovationHub> reccomendations = provider2.recomendations;
    print(reccomendations);
    final lenth_left = (MediaQuery.of(context).size.width * 8/25)-MediaQuery.of(context).size.width / 30;



    return Scaffold(
      backgroundColor: tBackground,
      body: Center(
        child: Column(
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
                          Text("fau innohub",style: TextStyle(
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
            Expanded(
              child: Container(
                color: tBackground,
                child: Padding(
                  padding: EdgeInsets.fromLTRB(0, MediaQuery.of(context).size.height*0.05, 0,0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: MediaQuery.of(context).size.width *(186/1512),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            GestureDetector(
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
                            SizedBox(
                              height: MediaQuery.of(context).size.height *(16/1032),
                            ),
                            Text("Details",
                              style: TextStyle(
                                  fontSize: 16,
                                  color: tPrimaryColorText
                              ),),
                            Container(
                              width: MediaQuery.of(context).size.width * 5/25,
                              child: Divider(
                              ),
                            ),
                            ListView.builder(
                                shrinkWrap: true,
                                itemCount: menuItems.length,
                                itemBuilder: (context, index) {
                                  if(menuItems[index] == "About"){
                                    return GestureDetector(
                                      onTap: (){
                                          setState(() {
                                            isEventSelected = false;
                                            isWorkSelected = false;
                                            isAboutViewSelected = true;
                                            isContactSelected = false;
                                          });
                                      },
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(menuItems[index],
                                            style: TextStyle(
                                              fontSize: 40,
                                              color: tPrimaryColorText,
                                              fontWeight: FontWeight.bold
                                            ),),
                                          SizedBox(
                                            height: 10,
                                          )
                                        ],
                                      ),
                                    );
                                  }
                                  if(menuItems[index] == "Contact"){
                                    return GestureDetector(
                                      onTap: (){
                                        setState(() {
                                          isEventSelected = false;
                                          isWorkSelected = false;
                                          isAboutViewSelected = false;
                                          isContactSelected = true;
                                        });
                                      },
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(menuItems[index],
                                            style: TextStyle(
                                            fontSize: 40,
                                            color: tPrimaryColorText,
                                                fontWeight: FontWeight.bold
                                          ),),
                                          SizedBox(
                                            height: 10,
                                          )
                                        ],
                                      ),
                                    );
                                  } if(menuItems[index] == "Events"){
                                    return GestureDetector(
                                      onTap: (){
                                        setState(() {
                                          isEventSelected = true;
                                          isWorkSelected = false;
                                          isAboutViewSelected = false;
                                          isContactSelected = false;
                                        });
                                      },
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(menuItems[index],
                                            style: TextStyle(
                                            fontSize: 40,
                                            color: tPrimaryColorText,
                                                fontWeight: FontWeight.bold
                                          ),),
                                          SizedBox(
                                            height: 10,
                                          )
                                        ],
                                      ),
                                    );
                                  } if(menuItems[index] == "Research"){
                                    return GestureDetector(
                                      onTap: (){
                                        setState(() {
                                          isEventSelected = false;
                                          isWorkSelected = true;
                                          isAboutViewSelected = false;
                                          isContactSelected = false;
                                        });
                                      },
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(menuItems[index],
                                            style: TextStyle(
                                              fontSize: 40,
                                              color: tPrimaryColorText,
                                                fontWeight: FontWeight.bold
                                            ),),
                                          SizedBox(
                                            height: 10,
                                          )
                                        ],
                                      ),
                                    );
                                  }
                                },
                              ),
                            SizedBox(
                              height:(MediaQuery.of(context).size.height* (8/1032)),
                            ),
                            Expanded(
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text("We also reccomend",
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: tPrimaryColorText
                                    ),),
                                    Container(
                                      width: MediaQuery.of(context).size.width * 5/25,
                                      child: Divider(
                                      ),
                                    ),
                                    SizedBox(
                                      height:(MediaQuery.of(context).size.height* (14/1032)),
                                    ),
                                    Flexible(
                                      child: ListView.builder(
                                        shrinkWrap: true,
                                        itemCount: reccomendations.length +
                                            (reccomendations.isEmpty ? 1 : 0),
                                        itemBuilder: (context, index) {
                                          if (reccomendations.isNotEmpty) {
                                            return Row(
                                              children: [
                                                Container(
                                                  child: GestureDetector(
                                                    onTap: () async {
                                                      await provider.getHubInfoByCode(reccomendations[index].code,reccomendations[index].filtered_chips);
                                                      await provider.getMenu();
                                                      provider2.calculate_recomendations(provider2.getInnovationHubByCode(reccomendations[index].code));
                                                      await provider3.getEventListFromUidList(provider.detailedInnovationHub.events);
                                                      await provider4.getHubworksListFromUidList(provider.detailedInnovationHub.work);
                                                      Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                          builder: (context) => InnovationHubDetailPage(stringList: reccomendations[index].filtered_chips),
                                                        ),
                                                      );
                                                    },
                                                    child: Column(
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      children: [
                                                        FutureBuilder(
                                                          future: _loadProfileImage(reccomendations[index].profileImagePath),
                                                          builder: (context, snapshot) {
                                                            if (snapshot.connectionState == ConnectionState.done) {
                                                              return SizedBox(
                                                                height: MediaQuery.of(context).size.width * (186/1512),
                                                                width: MediaQuery.of(context).size.width * (186/1512),
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
                                                        SizedBox(
                                                          height:(MediaQuery.of(context).size.height* (5/1080)),
                                                        ),
                                                        Text(reccomendations[index].name,
                                                          style: TextStyle(
                                                            fontSize: 24,
                                                            color: tPrimaryColorText,
                                                            fontWeight: FontWeight.w700
                                                          ),
                                                        maxLines: 2,),
                                                        SizedBox(
                                                          height:(MediaQuery.of(context).size.height* (14/1080)),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                                Spacer()
                                              ],
                                            );
                                          } else {
                                            return Row(
                                              children: [
                                                Container(
                                                  child: Column(
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: [
                                                      FutureBuilder(
                                                        future: _loadProfileImage("gs://cohort1innovationandleadership.appspot.com/Images/Storysetdump/Hubsearch.svg"),
                                                        builder: (context, snapshot) {
                                                          if (snapshot.connectionState == ConnectionState.done) {
                                                            return SizedBox(
                                                              height: MediaQuery.of(context).size.width * 4/25,
                                                              width: MediaQuery.of(context).size.width * 4/25,
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
                                                      SizedBox(
                                                        height:(MediaQuery.of(context).size.height* (10/1080)),
                                                      ),
                                                      Text("This Innovation Hub is unique. WHAT!",
                                                        style: TextStyle(
                                                          fontSize: 24,
                                                          color: tPrimaryColorText,
                                                          fontWeight: FontWeight.w700
                                                      ),),
                                                    ],
                                                  ),
                                                ),
                                                Spacer()
                                              ],
                                            );
                                          }
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                          ],
                        ),
                      ),
                      isAboutViewSelected
                          ? AboutWidget(info.detailedDescription, info.headerImage, info.name)
                          : isWorkSelected
                          ? WorkWidget(Research, info.name, true)
                          : isEventSelected
                          ? EventWidget(events, info.name)
                          : isContactSelected
                          ? ContactWidget(Contacts, info.name, true)
                          :Container(
                        width: MediaQuery.of(context).size.width *(1156/1512),
                        decoration:  BoxDecoration(
                            color: tWhite,
                          borderRadius: BorderRadius.vertical(top: Radius.circular(20))
                        ),
                        child: SingleChildScrollView(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              FutureBuilder(
                                future: _loadProfileImage(info.headerImage),
                                builder: (context, snapshot) {
                                  if (snapshot.connectionState ==
                                      ConnectionState.done) {
                                    return ClipRRect(
                                      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                                      child: Image(
                                              height: MediaQuery.of(context).size.height * (243/982),
                                        width: MediaQuery.of(context).size.width *(1156/1512),
                                        image: snapshot.data as ImageProvider,
                                        fit: BoxFit.cover,
                                      ),
                                    );
                                  } else {
                                    return Container();
                                  }
                                },
                              ),
                              Padding(
                                padding: EdgeInsets.symmetric(vertical: 0,horizontal:MediaQuery.of(context).size.width*(32/1512) ),
                                child: ListView.builder(
                                  shrinkWrap: true,
                                  itemCount: menuItems.length,
                                  itemBuilder: (context, index) {
                                    if(menuItems[index] == "About"){
                                      return Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [SizedBox(
                                          height: MediaQuery.of(context).size.height*(20/1032),
                                        ),
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(info.name, style: TextStyle(
                                                fontSize: 32,
                                                fontWeight: FontWeight.w700,
                                              ),
                                              ),
                                              if (info.filtered_chips.isNotEmpty)
                                                Wrap(
                                                  runSpacing: 5,
                                                  spacing: MediaQuery.of(context).size.width * (16 / 1512),
                                                  children: info.filtered_chips.map((chip) {
                                                    return Container(
                                                      height: MediaQuery
                                                          .of(context)
                                                          .size
                                                          .height *(44/982),
                                                      decoration: BoxDecoration(
                                                        border: Border.all(
                                                          width: 2,
                                                          color: tBlue,
                                                        ),
                                                        borderRadius: BorderRadius.circular(MediaQuery.of(context).size.height *(22/982), ),
                                                      ),
                                                      padding: EdgeInsets.fromLTRB(MediaQuery.of(context).size.width * (25/1512),0, MediaQuery.of(context).size.width * (25/1512), 0),
                                                      child: Center(
                                                        child: Text(

                                                          chip,

                                                          style: TextStyle(
                                                            fontSize: 20,
                                                            fontWeight: FontWeight.w600,
                                                            color: tBlue,
                                                          ),
                                                        ),
                                                      ),
                                                    );
                                                  }).toList(),
                                                )
                                              else
                                                SizedBox(
                                                  width: 8,
                                                ),
                                            ],
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.symmetric(vertical: 10),
                                            child: Text("About",style: TextStyle(
                                              fontSize: 24,
                                              fontWeight: FontWeight.w700,
                                            ),),
                                          ),
                                          Text(info.detailedDescription,
                                            style: TextStyle(
                                              fontSize: 24,
                                              fontWeight: FontWeight.w400,
                                            ),),
                                        ],
                                      );
                                    }
                                    if(menuItems[index] == "Contact"){
                                      return ContactWidget(Contacts, info.name, false);
                                    } if(menuItems[index] == "Events"){
                                      return Column(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          if(events.length > 1)
                                            Text("Events",style: TextStyle(
                                              fontSize: 24,
                                              fontWeight: FontWeight.w700,
                                            ),),
                                          if(events.length == 1)
                                            Padding(
                                              padding: EdgeInsets.symmetric(vertical: 8.0),
                                              child: Text("Event",style: TextStyle(
                                                fontSize: 24,
                                                fontWeight: FontWeight.w700,
                                                ),),
                                            ),
                                          ListView.builder(
                                          shrinkWrap: true,
                                          itemCount: events.length,
                                          itemBuilder: (context, index) {
                                            return Padding(
                                              padding: EdgeInsets.symmetric(vertical: 8.0),
                                              child: EventListItem(Event: events[index], Lenght: (MediaQuery.of(context).size.width * (1095/1512)),detail: true, ),
                                            );
                                          }
                                          ),
                                        ],
                                      );
                                    } if(menuItems[index] == "Research"){
                                      return Column(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          if(Research.length > 1)
                                            Text("Research",style: TextStyle(
                                              fontSize: 24,
                                              fontWeight: FontWeight.w700,
                                            ),),
                                          if(Research.length == 1)
                                            Padding(
                                              padding: EdgeInsets.symmetric(vertical: 8.0),
                                              child: Text("Research",style: TextStyle(
                                                fontSize: 24,
                                                fontWeight: FontWeight.w700,
                                              ),),
                                            ),
                                          ListView.builder(
                                              shrinkWrap: true,
                                              itemCount: Research.length,
                                              itemBuilder: (context, index) {
                                                return Padding(
                                                  padding: EdgeInsets.symmetric(vertical: 8.0),
                                                  child: ResearchListItem(Work: Research[index], Lenght: (MediaQuery.of(context).size.width * (1095/1512)),detail: true, ),
                                                );
                                              }
                                          ),
                                        ],
                                      );
                                    }
                                  },
                                ),
                                )
                                  ],
                                ),
                              )
                      )
                            ],
                          ),
                        ),
                      ),
            ),
                    ],
                  ),
              ),
            );

  }
}


class DetailContactWidget extends StatelessWidget {
  final Map<String, String> contacts;
  final String name;

  DetailContactWidget(this.contacts,this.name);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text("Feel Free To Contact $name!",
            style: TextStyle(
                fontSize: 64,
                fontWeight: FontWeight.w700,
                color: tPrimaryColorText
            ),),
          Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildContactInfo("Website", contacts["Website"], Uri(
                    scheme: 'https',
                    path: contacts["Website"]
                )),
                _buildContactInfo("TeleContact", contacts["TeleContact"], Uri(
                    scheme: 'tel',
                    path: contacts["TeleContact"]
                )),
                _buildContactInfo("EmailContact", contacts["EmailContact"], Uri(
                    scheme: 'mailto',
                    path: contacts["EmailContact"]
                )),
                _buildContactInfo("Latitude", contacts["Latitude"], Uri(
                    scheme: 'https',
                    path: contacts["Latitud"]
                )),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContactInfo(String label, String? value, Uri link) {

    if (value != null && value.isNotEmpty) {
      IconData icon;
      String iconName = label.toLowerCase();

      switch (iconName) {
        case "website":
          icon = Icons.link;
          break;
        case "telecontact":
          icon = Icons.phone;
          break;
        case "emailcontact":
          icon = Icons.email;
          break;
        case "latitude":
        case "longitude":
          icon = Icons.location_on;
          break;
        default:
          icon = Icons.info;
      }

      // Wenn es Latitude oder Longitude ist, die beiden Informationen in einer Zeile anzeigen
      if (iconName == "latitude" ) {
        String? Lon = contacts["Longitude"];
        return Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 20.0,
            ),
            SizedBox(width: 8.0),
            Text(
              "$value , $Lon",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16.0,
              ),
            ),
            SizedBox(height: 16.0),
          ],
        );
      } else {
        return Row(
          children: [
            Icon(
              icon,
              size: 20.0,
            ),
            SizedBox(width: 8.0),
            buildLinkText(link, value),
          ],
        );
      }
    } else {
      return Container();
    }
  }
}

Widget buildLinkText(Uri link, String linkstring) {
  // Erstelle einen klickbaren Link
  final recognizer = TapGestureRecognizer()
    ..onTap = () async {
      _launchInBrowser(link);
    };

  return RichText(
    text: TextSpan(
      text: linkstring,
      style: TextStyle(
        color: Colors.blue,
        decoration: TextDecoration.underline,
      ),
      recognizer: recognizer,
    ),
  );
}

Future<void> _launchInBrowser(Uri url) async {
  if (!await launchUrl(
    url,
    mode: LaunchMode.externalApplication,
  )) {
    throw Exception('Could not launch $url');
  }
}
