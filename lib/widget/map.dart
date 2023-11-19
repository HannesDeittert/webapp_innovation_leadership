import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';

import '../datamanager/DetailedHubInfoProvider.dart';
import '../datamanager/InnovationHub.dart';
import '../datamanager/InnovationHubProvider.dart';
import 'innovationhubdetailpage.dart';

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
                              detailedHubInfoProvider.loadDetailedHubInfo(hub.code);

                              // Zur Detailseite navigieren
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => InnovationHubDetailPage(),
                                ),
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
      case 'StartUp':
        return Icons.start_sharp;
      default:
        return Icons.info;
    }
  }
}



