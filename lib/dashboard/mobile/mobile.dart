import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:webapp_innovation_leadership/Constants/Colors.dart';

import '../../datamanager/InnovationHub.dart';
import '../../widget/MyListView.dart';
import '../../widget/header.dart';
import '../../widget/map.dart';



class MobileDashboard extends StatefulWidget {
  @override
  _MobileDashboardState createState() => _MobileDashboardState();
}

class _MobileDashboardState extends State<MobileDashboard> {

  void onFilterChange(List<InnovationHub> newFilteredHubs) {
    // Implementieren Sie hier die Logik, die ausgeführt werden soll,
    // wenn die gefilterte Liste sich ändert (z.B. Aktualisierung des Zustands, etc.)
    setState(() {
      filteredHubs = newFilteredHubs;
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: tPrimaryColor,
      appBar: AppBar(
        title: const Header(),
      ),
      body: Center(
        child: InnoMap(),
      ),
    );
  }
}