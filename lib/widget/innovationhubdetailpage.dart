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


  Future<Widget> _loadLeadingImage() async {
    try {
      final ref = firebase_storage.FirebaseStorage.instance.ref(imagePath);
      final url = await ref.getDownloadURL();
      print(url);

      final imageWidget = Image.network(url);

      return Container(
        width: 100,
        height: 100,
        child: imageWidget,
      );
    } catch (e) {
      print('Fehler beim Laden des Bildes: $e');
      return Image.asset('assets/placeholder_image.jpg');
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
      body: Center(
        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border(
                  bottom: BorderSide(
                    width: 1,
                    color: Color.fromARGB(0xFF, 0x55, 0x55, 0x55),
                  ),
                ),
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: MediaQuery.of(context).size.width / 30,
                  vertical: 0.0,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    FutureBuilder(
                      future: _loadLeadingImage(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.done) {
                          return snapshot.data!;
                        } else if (snapshot.hasError) {
                          return Icon(Icons.error);
                        } else {
                          return CircularProgressIndicator();
                        }
                      },
                    ),
                    IconButton(
                      onPressed: () {
                        SideSheet.right(
                          sheetBorderRadius: 10,
                          context: context,
                          width: MediaQuery.of(context).size.width * 0.2,
                          body: PopUPContent(context),
                        );
                      },
                      icon: Icon(Icons.menu, color: Colors.black),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              child: Container(
                color: Colors.white,
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
