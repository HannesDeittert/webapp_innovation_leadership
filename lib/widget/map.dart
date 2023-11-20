import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';

import '../datamanager/DetailedHubInfoProvider.dart';
import '../datamanager/InnovationHub.dart';
import '../datamanager/InnovationHubProvider.dart';
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

        return Container(
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
                              // Den DetailedHubInfoProvider vom Kontext abrufen
                              DetailedHubInfoProvider detailedHubInfoProvider = Provider.of<DetailedHubInfoProvider>(context, listen: false);

                              // _detailedHubInfo über die loadDetailedHubInfo-Methode initialisieren
                              //detailedHubInfoProvider.loadDetailedHubInfo(hub.code);

                              // Zur Detailseite navigiere
                              SideSheet.right(
                                sheetBorderRadius: 10,
                                context: context,
                                width: MediaQuery.of(context).size.width * 0.2,
                                body: PopUPContent(context, hub)
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

  Widget PopUPContent(BuildContext context, InnovationHub hub) {
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
                onTap: () {
                  // Den DetailedHubInfoProvider vom Kontext abrufen
                  DetailedHubInfoProvider detailedHubInfoProvider =
                  Provider.of<DetailedHubInfoProvider>(context, listen: false);
                  // _detailedHubInfo über die loadDetailedHubInfo-Methode initialisieren
                  detailedHubInfoProvider.getHubInfoByCode(hub.code);
                  // Hier zur InnovationHubDetailPage navigieren
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


