import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

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
    hubs = provider.mockupHubs;
  }

  void onFilterChange(List<InnovationHub> newFilteredHubs) {
    // Implementieren Sie hier die Logik, die ausgeführt werden soll,
    // wenn die gefilterte Liste sich ändert (z.B. Aktualisierung des Zustands, etc.)
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