import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:provider/provider.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:webapp_innovation_leadership/constants/colors.dart';
import '../datamanager/DetailedHubInfoProvider.dart';
import '../datamanager/EventProvieder.dart';
import '../datamanager/InnovationHub.dart';
import '../datamanager/InnovationHubProvider.dart';
import '../datamanager/WorkProvider.dart';
import 'innovationhubdetailpage.dart';

class MapPopup extends StatefulWidget {
  final Marker marker;

  const MapPopup(this.marker, {super.key});

  @override
  State<StatefulWidget> createState() => _MapPopupState();
}

class _MapPopupState extends State<MapPopup> {
  final InnovationHubProvider provider = InnovationHubProvider();

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            _cardDescription(context),
          ],
        ),
      ),
    );
  }

  Widget _cardDescription(BuildContext context) {
    return Consumer<InnovationHubProvider>(
        builder: (context, provider, child)
        {
          // Liste der gefilterten Hubs abrufen
          InnovationHub? Hub = provider.findHubByCoordinates(widget.marker.point);
          return Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
            ),
            height: MediaQuery
                .of(context)
                .size
                .height * (104 / 982),
            width: MediaQuery
                .of(context)
                .size
                .width * (350 / 1512),
            child: Padding(
              padding: EdgeInsets.all(MediaQuery
                  .of(context)
                  .size
                  .height * (16 / 982)),
              child: Row(
                children: [
                  FutureBuilder(
                    future: _loadProfileImage(Hub?.profileImagePath ?? ''),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.done) {
                        return Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5)
                          ),
                          height: MediaQuery
                              .of(context)
                              .size
                              .height * (72/982),
                          width: MediaQuery
                              .of(context)
                              .size
                              .height * (72/982),
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
                    width: MediaQuery
                        .of(context)
                        .size
                        .width * (12 / 1512),
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Text(Hub?.name ?? 'No Name', style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                            ),),
                            Spacer(),
                        GestureDetector(
                          onTap: () async {
                            // Den DetailedHubInfoProvider vom Kontext abrufen
                            DetailedHubInfoProvider detailedHubInfoProvider =
                            Provider.of<DetailedHubInfoProvider>(context, listen: false);
                            EventProvider provider3 = Provider.of<EventProvider>(context, listen:  false);
                            WorkProvider provider4 = Provider.of<WorkProvider>(context, listen:  false);
                            // _detailedHubInfo über die loadDetailedHubInfo-Methode initialisieren
                            if (Hub != null) {
                              await detailedHubInfoProvider.getHubInfoByCode(Hub.code,Hub.filtered_chips);
                            }
                            await detailedHubInfoProvider.getMenu();
                            await provider3.loadAllEvents();
                            await provider3.getEventListFromUidList(detailedHubInfoProvider.detailedInnovationHub.events);
                            await provider4.loadAllHubworks();
                            await provider4.getHubworksListFromUidList(detailedHubInfoProvider.detailedInnovationHub.work);
                            print(detailedHubInfoProvider.detailedInnovationHub);
                            if (Hub != null) {
                              provider.calculate_recomendations(Hub);
                            }
                            print(provider.recomendations);
                            // Zur Detailseite navigieren
                            if (Hub != null) {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      InnovationHubDetailPage(
                                          stringList: Hub.filtered_chips),
                                ),
                              );
                            }
                          },
                          child: Row(
                            children: [
                              Text("Show Details", style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w700,
                                color: tBlue
                              ),),
                              Icon(
                                Icons.arrow_forward,
                                color: tBlue,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                        SizedBox(
                          height: MediaQuery
                              .of(context)
                              .size
                              .height * (4 / 982),
                        ),
                        Text(
                          Hub?.summary ?? 'No Name',
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        }
    );
  }
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
