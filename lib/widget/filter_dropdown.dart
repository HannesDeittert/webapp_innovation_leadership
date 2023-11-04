// Filter Dropdown Komponente
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../datamanager/DetailedHubInfoProvider.dart';
import '../datamanager/InnovationHub.dart';
import '../datamanager/InnovationHubProvider.dart';
import 'innovationhubdetailpage.dart';

class FilterDropdown extends StatelessWidget {
  final String filter;
  final Function(String) onFilterChanged;
  final List<InnovationHub> hubs;

  FilterDropdown({
    required this.filter,
    required this.onFilterChanged,
    required this.hubs,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      value: filter,
      onChanged: (value) => onFilterChanged(value!),
      items: [
        DropdownMenuItem<String>(
          value: '',
          child: Text('all'),
        ),
      ].followedBy(
        hubs.map((hub) => hub.category).toSet().map((category) => DropdownMenuItem<String>(
          value: category,
          child: Text(category),
        )),
      ).toList(),
      decoration: InputDecoration(
        labelText: 'Innovation Hub Type',
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
      ),
      hint: Text('Innovation Hub Type'),
      isExpanded: true,
    );
  }
}

// Hub List Tile Komponente
class HubListTile extends StatelessWidget {
  final InnovationHub hub;

  HubListTile({required this.hub});

  @override
  Widget build(BuildContext context) {

    // Zugriff auf den InnovationHubProvider
    InnovationHubProvider provider = Provider.of<InnovationHubProvider>(context);

    // Liste der gefilterten Hubs abrufen
    List<InnovationHub> hubs = provider.filteredHubs;

    return ListTile(
      leading: Icon(getIconForCategory(hub.category)),
      title: Text(hub.name),
      onTap: () {
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
    );
  }

  IconData getIconForCategory(String category) {
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