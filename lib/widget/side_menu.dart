import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../Constants/Colors.dart';
import '../datamanager/InnovationHub.dart';
import '../datamanager/InnovationHubProvider.dart';
import 'MyListView.dart';

class SideMenu extends StatefulWidget {
  const SideMenu({super.key});

  @override
  State<SideMenu> createState() => _SideMenu();
}

class _SideMenu extends State<SideMenu> {
  final InnovationHubProvider provider = InnovationHubProvider();
  List<InnovationHub> hubs = [];

  @override
  void initState() {
    super.initState();
    // Rufen Sie die Methode loadInnovationHubsFromFirestore auf und aktualisieren Sie den Zustand, wenn die Daten geladen sind
    provider.loadInnovationHubsFromFirestore().then((_) {
      setState(() {
        hubs = provider.innovationHubs;
        provider.createFilterdHubList(hubs);
        print(provider.filteredHubs[0].name);
      });
    });
  }

  @override
  Widget build(BuildContext context) {

    return Drawer(
      backgroundColor: tCardBgColor,
      child: MyListView(
        hubs: hubs,
      ),
    );
  }
}