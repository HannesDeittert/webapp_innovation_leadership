import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';

import '../datamanager/DetailedHubInfoProvider.dart';
import '../datamanager/InnovationHub.dart';
import '../datamanager/InnovationHubProvider.dart';
import 'filter_dropdown.dart';
import 'innovationhubdetailpage.dart';

class InnoHubListWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<InnovationHubProvider>(
      builder: (context, provider, child) {
        // Liste der gefilterten Hubs abrufen
        List<InnovationHub> filteredHubs = provider.filteredHubs;
        print(filteredHubs);

        return ListView.builder(
            itemCount: filteredHubs.length,
            itemBuilder: (context, index) =>
                HubListTile(hub: filteredHubs[index]),
          );
      },
    );
  }
}
