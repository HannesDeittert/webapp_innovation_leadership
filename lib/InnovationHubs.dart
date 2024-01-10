import 'dart:js';

import 'package:flutter/cupertino.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:webapp_innovation_leadership/widget/InnoHubListWidget.dart';
import 'package:webapp_innovation_leadership/widget/map.dart';
import 'Homepage.dart';
import 'InnoHubGeneral.dart';
import 'constants/colors.dart';
import 'datamanager/EventProvieder.dart';
import 'datamanager/InnovationHub.dart';
import 'datamanager/InnovationHubProvider.dart';
import 'datamanager/QuestionProvider.dart';

class InnovationHubs extends StatefulWidget {
  const InnovationHubs({Key? key}) : super(key: key);

  @override
  State<InnovationHubs> createState() => _InnovationHubState();
}

class _InnovationHubState extends State<InnovationHubs> {
  final InnovationHubProvider provider = InnovationHubProvider();
  final QuestionProvider provider2 = QuestionProvider();
  final EventProvider provider3 = EventProvider();
  bool isHomeViewSelected = false;
  bool isHubViewSelected = true;
  bool isEventViewSelected = false;
  bool isGuideViewSelected = false;
  bool isCommunityViewSelected = false;
  bool isDetailedViewSelected = false;
  final String imagePath = 'Images/FAU_INNOVATION_LOGO.png';

  @override
  void initState() {
    provider.loadInnovationHubsFromFirestore();
    provider2.loadQuestionsFromFirestore();
    provider3.loadAllEvents();
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

  @override
  Widget build(BuildContext context) {
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
            SizedBox(
              height: 8,
            ),
            Consumer<InnovationHubProvider>(
              builder: (context, provider, child) {
                // Liste der gefilterten Hubs abrufen
                List<InnovationHub> filteredHubs = provider.filteredHubs;
                return Expanded(
                  child: CustomScrollView(
                    slivers: [
                      SliverAppBar(
                        expandedHeight:
                        MediaQuery.of(context).size.height * (617 / 982),
                        flexibleSpace: InnoMap(),
                        pinned: false,
                      ),
                      SliverToBoxAdapter(
                        child: Container(
                          child: Column(
                            children: [
                              SizedBox(
                                height: MediaQuery.of(context).size.height * 0.031,
                              ),
                              Padding(
                                padding: EdgeInsets.fromLTRB((MediaQuery.of(context).size.width / 30), 0, 0, 0),
                                child: Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text("Your Results", style: TextStyle(
                                      fontSize: 32,
                                      fontWeight: FontWeight.w700
                                  ),),
                                ),
                              ),
                              SizedBox(
                                height: MediaQuery.of(context).size.height * 0.0155,
                              ),
                            ],
                          ),
                        ),
                      ),
                      SliverList(
                        delegate: SliverChildBuilderDelegate(
                              (BuildContext context, int index) {
                            return HubListItem(hub: filteredHubs[index]);
                          },
                          childCount: filteredHubs.length,
                        ),
                      ),
                    ],
                  ),
                );
              },
            )
          ]),
    );
  }
}