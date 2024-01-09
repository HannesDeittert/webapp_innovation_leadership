import 'dart:html';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';
import 'package:side_sheet/side_sheet.dart';
import 'package:webapp_innovation_leadership/datamanager/DetailedHubInfo.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:webapp_innovation_leadership/datamanager/Work.dart';

import '../Constants/Colors.dart';
import '../datamanager/DetailedHubInfoProvider.dart';

import '../datamanager/EventProvieder.dart';
import '../datamanager/Events.dart';
import '../datamanager/InnovationHub.dart';
import '../datamanager/InnovationHubProvider.dart';
import '../datamanager/WorkProvider.dart';
import '../login/login_screen.dart';
import 'PopUpContent.dart';
import 'detailed_widget/AboutWidget.dart';
import 'detailed_widget/ContactWidget.dart';
import 'detailed_widget/EventWidget.dart';
import 'detailed_widget/WorkWidget.dart';

class InnovationHubDetailPage extends StatefulWidget {
  @override
  _InnovationHubDetailPageState createState() => _InnovationHubDetailPageState();
}

class _InnovationHubDetailPageState extends State<InnovationHubDetailPage> {
  final String imagePath = 'Images/FAU_INNOVATION_LOGO.png';
  bool isEventSelected = false;
  bool isWorkSelected = false;
  bool isAboutViewSelected = true;
  bool isContactSelected = false;
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
    List<HubEvents> events = provider3.Hubevents;
    List<HubWork> work = provider4.Hubworks;
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
                    bottom: BorderSide(width: 1, color: tBackground),
                  )),
              child: Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: MediaQuery.of(context).size.width / 30,
                    vertical: 0.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
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
                    SizedBox(
                      width: 100,
                    )
                  ],
                ),
              ),
            ),
            Expanded(
              child: Container(
                color: tBackground,
                child: Padding(
                  padding:  EdgeInsets.symmetric(
                    vertical: MediaQuery.of(context).size.width/60
                  ),
                  child: Row(
                    children: [
                      SizedBox(width: MediaQuery.of(context).size.width / 30,),
                      Container(
                        width: lenth_left,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
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
                                            height: 20,
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
                                            height: 20,
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
                                            height: 20,
                                          )
                                        ],
                                      ),
                                    );
                                  } if(menuItems[index] == "Work"){
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
                                            height: 20,
                                          )
                                        ],
                                      ),
                                    );
                                  }
                                },
                              ),
                            Container(
                              width: MediaQuery.of(context).size.width * 5/25,
                              child: Divider(

                              ),
                            ),
                            Expanded(
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text("We also reccomend",
                                    style: TextStyle(
                                      fontSize: 32,
                                      color: tPrimaryColorText
                                    ),),
                                    SizedBox(
                                      height:(MediaQuery.of(context).size.height* (50/1080)) ,
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
                                                      await provider.getHubInfoByCode(reccomendations[index].code);
                                                      await provider.getMenu();
                                                      provider2.calculate_recomendations(provider2.getInnovationHubByCode(reccomendations[index].code));
                                                      await provider3.getEventListFromUidList(provider.detailedInnovationHub.events);
                                                      await provider4.getHubworksListFromUidList(provider.detailedInnovationHub.work);
                                                      Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                          builder: (context) => InnovationHubDetailPage(),
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
                                                        Text(reccomendations[index].name,
                                                          style: TextStyle(
                                                            fontSize: 24,
                                                            color: tPrimaryColorText,
                                                            fontWeight: FontWeight.w700
                                                          ),),
                                                        SizedBox(
                                                          height:(MediaQuery.of(context).size.height* (25/1080)),
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
                      Spacer(),
                      Container(
                        width: (MediaQuery.of(context).size.width -(MediaQuery.of(context).size.width * 8/25)-MediaQuery.of(context).size.width / 30)- MediaQuery.of(context).size.width / 60,
                        child: Column(
                          children: [
                            Expanded(
                              child: isAboutViewSelected
                                  ? AboutWidget(info.detailedDescription,info.headerImage, info.name)
                                  : isWorkSelected ? WorkWidget(work, info.name) : (isEventSelected ? EventWidget(events, info.name) : ContactWidget(Contacts, info.name))
                            ), // Falls weder ListView noch MapView ausgewählt ist, wird ein leeres Container-Widget verwendet
                          ],
                        ),
                      ),
                      SizedBox(width: MediaQuery.of(context).size.width / 30,),
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
