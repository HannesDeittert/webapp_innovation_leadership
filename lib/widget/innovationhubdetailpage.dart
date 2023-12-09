import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:side_sheet/side_sheet.dart';
import 'package:webapp_innovation_leadership/datamanager/DetailedHubInfo.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

import '../Constants/Colors.dart';
import '../datamanager/DetailedHubInfoProvider.dart';

import '../datamanager/InnovationHub.dart';
import '../datamanager/InnovationHubProvider.dart';
import '../login/login_screen.dart';
import 'PopUpContent.dart';

class InnovationHubDetailPage extends StatefulWidget {
  @override
  _InnovationHubDetailPageState createState() => _InnovationHubDetailPageState();
}

class _InnovationHubDetailPageState extends State<InnovationHubDetailPage> {
  final String imagePath = 'Images/FAU_INNOVATION_LOGO.png';


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

  @override
  Widget build(BuildContext context) {
    DetailedHubInfoProvider provider = Provider.of<DetailedHubInfoProvider>(context);
    InnovationHubProvider provider2 = Provider.of<InnovationHubProvider>(context);
    DetailedHubInfo info = provider.detailedInnovationHub;
    List<String> menuItems = provider.Menu;
    List<InnovationHub> reccomendations = provider2.recomendations;
    print(reccomendations);
    final lenth_left = (MediaQuery.of(context).size.width * 8/25)-MediaQuery.of(context).size.width / 30;
    final image_width = MediaQuery.of(context).size.width *(1259/1920);
    final image_height = MediaQuery.of(context).size.height *(541/1080);


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
                            Container(
                              child: ListView.builder(
                                shrinkWrap: true,
                                itemCount: menuItems.length,
                                itemBuilder: (context, index) {
                                  if(menuItems[index] == "About"){
                                    return Column(
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
                                    );
                                  }
                                  if(menuItems[index] == "Contact"){
                                    return Column(
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
                                    );
                                  } if(menuItems[index] == "Events"){
                                    return Column(
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
                                    );
                                  } if(menuItems[index] == "Work"){
                                    return Column(
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
                                    );
                                  }
                                },
                              ),
                            ),
                            Container(
                              width: MediaQuery.of(context).size.width * 5/25,
                              child: Divider(

                              ),
                            ),
                            Container(
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
                            Spacer()
                          ],
                        ),
                      ),
                      Spacer(),
                      Container(
                        width: (MediaQuery.of(context).size.width -(MediaQuery.of(context).size.width * 8/25)-MediaQuery.of(context).size.width / 30)- MediaQuery.of(context).size.width / 60,
                        child: Column(
                          children: [
                            FutureBuilder(
                              future: _loadProfileImage(info.headerImage),
                              builder: (context, snapshot) {
                                if (snapshot.connectionState ==
                                    ConnectionState.done) {
                                  return SizedBox(
                                    height: image_height,
                                    width: image_width,
                                    child: Image(
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
                              height: MediaQuery.of(context).size.height * (1080/36) ,
                            ),
                            Container(
                              width:
                              MediaQuery.of(context).size.width * (2.5 / 4),
                              child: Text(info.name),
                            ),
                            Container(
                              width:
                              MediaQuery.of(context).size.width * (2.5 / 4),
                              child: Text(info.events[0]),
                            ),
                            Container(
                              width:
                              MediaQuery.of(context).size.width * (2.5 / 4),
                              child: Text(info.detailedDescription),
                            ),
                            // ... Weitere Informationen für den InnovationHub anzeigen
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
