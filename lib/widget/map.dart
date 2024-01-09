import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';
import 'package:webapp_innovation_leadership/constants/colors.dart';

import '../datamanager/DetailedHubInfoProvider.dart';
import '../datamanager/EventProvieder.dart';
import '../datamanager/InnovationHub.dart';
import '../datamanager/InnovationHubProvider.dart';
import '../datamanager/WorkProvider.dart';
import 'innovationhubdetailpage.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:side_sheet/side_sheet.dart';
import '../datamanager/DetailedHubInfoProvider.dart';

class InnoMap extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<InnovationHubProvider>(
      builder: (context, provider, child) {
        // Liste der gefilterten Hubs abrufen
        List<InnovationHub> filteredHubs = provider.filteredHubs;
        print(filteredHubs);

        return Stack(
          children: [
            Container(
              child: Column(
                children: [
                  Flexible(
                    child: FlutterMap(
                      options: MapOptions(
                          cameraConstraint: CameraConstraint.contain(
                            bounds: LatLngBounds(
                              LatLng(49.135171, 10.515910),
                              LatLng(49.881752, 11.509370),
                            ),
                          ),
                          initialCenter: LatLng(49.47593, 10.98856)),
                      children: [
                        TileLayer(
                          urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                          userAgentPackageName: 'com.example.app',
                        ),
                        // Erstellen Sie MarkerLayer dynamisch basierend auf der gefilterten Liste von InnovationHubs
                        MarkerLayer(
                          markers: filteredHubs.map((hub) {
                            return Marker(
                              point: hub.coordinates,
                              child: IconButton(
                                iconSize: 50,
                                onPressed: () {
                                  // Zur Detailseite navigiere
                                  SideSheet.right(
                                    sheetBorderRadius: 10,
                                    context: context,
                                    width: MediaQuery.of(context).size.width * 0.2,
                                    body: PopUPContentMap(context, hub)
                                  );
                                },
                                icon: Icon(_getIconForCategory(hub.category)),
                              ),
                            );
                          }).toList(),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
              bottom: MediaQuery.of(context).size.height * (31/1967),
              right: MediaQuery.of(context).size.width * (475 / 491) - MediaQuery.of(context).size.width * (365 / 1512),
              child: Container(
                height:  MediaQuery.of(context).size.height * (586 / 982),
                width: MediaQuery.of(context).size.width * (365 / 1512),
                decoration: BoxDecoration(
                  color: tWhite,
                  borderRadius: BorderRadius.circular(20)
                ),
                child:
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Text(
                            'Filters',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),
                          Spacer()
                        ],
                      ),
                      SizedBox(height: 10),
                      TextField(
                        decoration: InputDecoration(
                          labelText: 'Search Tags',
                          border: OutlineInputBorder(),
                        ),
                      ),
                      SizedBox(height: 16),
                      Text(
                        'Selected Location Type Tags:',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      // Widget to display selected Location Type tags
                      // ...

                      SizedBox(height: 16),
                      Text(
                        'Selected Category of Interest Tags:',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      // Widget to display selected Category of Interest tags
                      // ...

                      SizedBox(height: 16),
                      Text(
                        'Location is a part of FAU:',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Column(
                        children: [
                          GestureDetector(
                            onTap: () {
                              // Handle selection for 'Yes'
                              // ...
                            },
                            child: Row(
                              children: [
                                Container(
                                  width: 20,
                                  height: 20,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Colors.blue, // Change color based on selection
                                  ),
                                ),
                                SizedBox(width: 10),
                                Text('Yes'),
                              ],
                            ),
                          ),
                          SizedBox(height: 20),
                          GestureDetector(
                            onTap: () {
                              // Handle selection for 'No'
                              // ...
                            },
                            child: Row(
                              children: [
                                Container(
                                  width: 20,
                                  height: 20,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: Colors.grey, // Change color based on selection
                                    ),
                                  ),
                                ),
                                SizedBox(width: 10),
                                Text('No'),
                              ],
                            ),
                          ),
                        ],
                      ),
                      Spacer(),
                      Row(
                        children: [
                          Spacer(),
                          GestureDetector(
                            child: Container(
                              height:  MediaQuery.of(context).size.height * (60 / 982),
                              width: MediaQuery.of(context).size.width * (317/ 1512),
                              decoration: BoxDecoration(
                                color: Colors.blue,
                                borderRadius: BorderRadius.circular((MediaQuery.of(context).size.height * (60 / 982))/2,)
                              ),
                              child: Center(
                                child: Text(
                                  'Display',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Spacer(),
                        ],
                      )
                    ],
                  ),
                ),
              )
            ),
          ],
        );
      },
    );
  }

  IconData _getIconForCategory(String category) {
    switch (category) {
      case 'university':
        return Icons.school;
      case 'company':
        return Icons.business;
      case 'socialInstitution':
        return Icons.group;
      default:
        return Icons.info;
    }
  }
}

  Widget PopUPContentMap(BuildContext context, InnovationHub hub) {

    return Container(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Container(
                child: Column(
                  children: [
                    FutureBuilder(
                      future: _loadProfileImage(hub.profileImagePath),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.done) {
                          return SizedBox(
                            height: MediaQuery.of(context).size.width*0.18,
                            width: MediaQuery.of(context).size.width*0.18,
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
                    SizedBox(height: 10),
                    // Name
                    Text(
                      hub.name,
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
              // Summary
              Text(
                hub.summary,
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 18, color: Colors.grey,),
              ),
              // Chips
              Wrap(
                spacing: 5,
                runSpacing: 5,
                children: hub.filtered_chips.map((chip) {
                  return Chip(
                    label: Text(chip),
                  );
                }).toList(),
              ),
              // Show More Button
              GestureDetector(
                onTap: () async {
                  DetailedHubInfoProvider provider = Provider.of<DetailedHubInfoProvider>(context, listen: false);
                  InnovationHubProvider provider2 = Provider.of<InnovationHubProvider>(context, listen: false);
                  EventProvider provider3 = Provider.of<EventProvider>(context, listen: false);
                  WorkProvider provider4 = Provider.of<WorkProvider>(context, listen: false);
                  await provider.getHubInfoByCode(hub.code);
                  await provider.getMenu();
                  provider2.calculate_recomendations(provider2.getInnovationHubByCode(hub.code));
                  await provider3.loadAllEvents();
                  await provider3.getEventListFromUidList(provider.detailedInnovationHub.events);
                  await provider4.loadAllHubworks();
                  await provider4.getHubworksListFromUidList(provider.detailedInnovationHub.work);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => InnovationHubDetailPage(),
                    ),
                  );
                },
                child: Text(
                  'Show More',
                  style: TextStyle(color: Colors.blue, fontSize: 16),
                ),
              ),
            ],
          ),
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


