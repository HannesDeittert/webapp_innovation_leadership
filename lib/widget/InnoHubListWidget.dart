import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import '../constants/colors.dart';
import '../datamanager/DetailedHubInfoProvider.dart';
import '../datamanager/EventProvieder.dart';
import '../datamanager/InnovationHub.dart';
import '../datamanager/InnovationHubProvider.dart';
import '../datamanager/WorkProvider.dart';
import 'innovationhubdetailpage.dart';

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

  HubListItem({required this.hub,});


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
                              return ClipRRect(
                                  borderRadius: BorderRadius.vertical(top: Radius.circular(20),bottom: Radius.circular(20)),
                            child: SizedBox(
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
                              ));
                            } else {
                              return Container(); // Hier könnte ein Ladeindikator eingefügt werden
                            }
                          },
                        ),
                        SizedBox(width: 30),
                        Expanded(
                          child: Container(
                            height: MediaQuery
                                .of(context)
                                .size
                                .height * (125/491),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,

                              children: [
                                Text(
                                  hub.name,
                                  style: TextStyle(fontSize: 32,
                                      fontWeight: FontWeight.bold,
                                      color: Color.fromARGB(0xFF, 0x55, 0x55, 0x55)),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                Spacer(),
                                Container(
                                  width: (MediaQuery.of(context).size.width * (173/189))-(MediaQuery.of(context).size.width * (16 / 491)+MediaQuery.of(context).size.height*(29/491)+ MediaQuery.of(context).size.height * (125/491)+30+MediaQuery.of(context).size.height * (41/982)),
                                  child: AutoSizeText(
                                    hub.summary,
                                    style: TextStyle(fontSize: 28,
                                        color: Color.fromARGB(0xFF, 0x55, 0x55, 0x55)),
                                    maxLines: 3,
                                  ),
                                ),
                                Spacer(),

                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    if (hub.filtered_chips.isNotEmpty)
                                      Wrap(
                                        runSpacing: 5,
                                        spacing: MediaQuery.of(context).size.width * (16 / 1512),
                                        children: hub.filtered_chips.map((chip) {
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
                              ],
                            ),
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
                        await detailedHubInfoProvider.getHubInfoByCode(hub.code,hub.filtered_chips);
                        await detailedHubInfoProvider.getMenu();
                        await provider3.loadAllEvents();
                        await provider3.getEventListFromUidList(detailedHubInfoProvider.detailedInnovationHub.events);
                        await provider4.loadAllHubworks();
                        await provider4.getHubworksListFromUidList(detailedHubInfoProvider.detailedInnovationHub.work);
                        provider.calculate_recomendations(hub);

                        List<String> chips = hub.filtered_chips;
                        String String_ = chips.toString();
                        print("In the list: $String_");
                        // Zur Detailseite navigieren
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => InnovationHubDetailPage(stringList: chips,),
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

