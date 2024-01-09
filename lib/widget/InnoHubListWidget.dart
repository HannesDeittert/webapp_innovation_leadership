import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import '../InnoHubGeneral.dart';
import '../constants/colors.dart';
import '../datamanager/DetailedHubInfoProvider.dart';
import '../datamanager/EventProvieder.dart';
import '../datamanager/InnovationHub.dart';
import '../datamanager/InnovationHubProvider.dart';
import '../datamanager/WorkProvider.dart';
import 'innovationhubdetailpage.dart';
import '../datamanager/DetailedHubInfoProvider.dart';

class InnoHubListWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: tBackground,
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: MediaQuery.of(context).size.width / 30,
          vertical: MediaQuery.of(context).size.height / 30,
        ),
        child: Consumer<InnovationHubProvider>(
          builder: (context, provider, child) {
            // Liste der gefilterten Hubs abrufen
            List<InnovationHub> filteredHubs = provider.filteredHubs;

            return ListView.builder(
              itemCount: filteredHubs.length,
              itemBuilder: (context, index) =>
                  HubListItem(hub: filteredHubs[index]),
            );
          },
        ),
      ),
    );
  }
}

class HubListItem extends StatelessWidget {
  final InnovationHub hub;


  HubListItem({required this.hub});

  @override
  Widget build(BuildContext context) {
    return Consumer<InnovationHubProvider>(
        builder: (context, provider, child) {
          return Column(
            children: [
              Stack(
                children: [
                  Container(
                    height: MediaQuery
                        .of(context)
                        .size
                        .height * (166/491),
                    width: MediaQuery
                        .of(context)
                        .size
                        .width * (173/189),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30),
                        color: tWhite
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(width: MediaQuery
                            .of(context)
                            .size
                            .height * (41/982),
                        ),
                        // Hier kannst du das Profilbild anzeigen
                        FutureBuilder(
                          future: _loadProfileImage(hub.profileImagePath),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState == ConnectionState.done) {
                              return SizedBox(
                                height: MediaQuery
                                    .of(context)
                                    .size
                                    .height * (125/491),
                                width: MediaQuery
                                    .of(context)
                                    .size
                                    .height * (125/491),
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
                        SizedBox(width: 10),
                        Container(
                          height: MediaQuery
                              .of(context)
                              .size
                              .height / 4,
                          width: MediaQuery
                              .of(context)
                              .size
                              .width * 0.5,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,

                            children: [
                              Text(
                                hub.name,
                                style: TextStyle(fontSize: 32,
                                    fontWeight: FontWeight.bold,
                                    color: Color.fromARGB(0xFF, 0x55, 0x55, 0x55)),
                              ),
                              Text(
                                hub.summary,
                                style: TextStyle(fontSize: 32,
                                    color: Color.fromARGB(0xFF, 0x55, 0x55, 0x55)),
                              ),
                              SizedBox(height: MediaQuery
                                  .of(context)
                                  .size
                                  .height / 20),

                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  if (hub.filtered_chips.isNotEmpty)
                                    Wrap(
                                      spacing: 5,
                                      children: hub.filtered_chips.map((chip) {
                                        return Chip(
                                          label: Text(
                                            chip,
                                            style: TextStyle(
                                              fontSize: 20,
                                              color: Color.fromARGB(0xFF, 0x55, 0x55, 0x55),
                                            ),
                                          ),
                                        );
                                      }).toList(),
                                    )
                                  else
                                    SizedBox(
                                      width: 8,
                                    ),
                                  SizedBox(width: MediaQuery
                                      .of(context)
                                      .size
                                      .height * (41/982),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),

                      ],
                    ),
                  ),
                  Positioned(
                    bottom: MediaQuery.of(context).size.height * (16 / 491),
                    right: MediaQuery.of(context).size.width * (16 / 491),
                    child: GestureDetector(
                      onTap: () async {
                        // Den DetailedHubInfoProvider vom Kontext abrufen
                        DetailedHubInfoProvider detailedHubInfoProvider =
                        Provider.of<DetailedHubInfoProvider>(context, listen: false);
                        EventProvider provider3 = Provider.of<EventProvider>(context, listen:  false);
                        WorkProvider provider4 = Provider.of<WorkProvider>(context, listen:  false);
                        // _detailedHubInfo über die loadDetailedHubInfo-Methode initialisieren
                        await detailedHubInfoProvider.getHubInfoByCode(hub.code);
                        await detailedHubInfoProvider.getMenu();
                        await provider3.loadAllEvents();
                        await provider3.getEventListFromUidList(detailedHubInfoProvider.detailedInnovationHub.events);
                        await provider4.loadAllHubworks();
                        await provider4.getHubworksListFromUidList(detailedHubInfoProvider.detailedInnovationHub.work);
                        print(detailedHubInfoProvider.detailedInnovationHub);
                        provider.calculate_recomendations(hub);
                        print(provider.recomendations);
                        // Zur Detailseite navigieren
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => InnovationHubDetailPage(),
                          ),
                        );
                      },
                      child: Container(
                        width: MediaQuery.of(context).size.height*(29/491),
                        height: MediaQuery.of(context).size.height*(29/491),
                        decoration: BoxDecoration(
                            color: tBackground,
                            borderRadius: BorderRadius.circular(MediaQuery.of(context).size.height*(29/491))
                        ),
                        child: Icon(
                          Icons.arrow_forward,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: MediaQuery
                  .of(context)
                  .size
                  .height * (21/982),
              ),
            ],
          );
        }
    );
  }

  Future<ImageProvider> _loadProfileImage(String path) async {
    try {
      final ref = firebase_storage.FirebaseStorage.instance.ref(path);
      final url = await ref.getDownloadURL();
      return NetworkImage(url);
    } catch (e) {
      // Fehlerbehandlung, wenn das Bild nicht geladen werden kann
      print('Fehler beim Laden des Profilbildes: $e');
      return AssetImage('assets/placeholder_image.jpg');
    }
  }
}

