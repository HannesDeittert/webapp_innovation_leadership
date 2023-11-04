import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:webapp_innovation_leadership/Constants/Colors.dart';
import 'package:webapp_innovation_leadership/widget/header.dart';
import 'package:webapp_innovation_leadership/widget/map.dart';

import '../../datamanager/InnovationHub.dart';
import '../../widget/MyListView.dart';


class DesktopDashboard extends StatefulWidget {
  @override
  _DesktopDashboardState createState() => _DesktopDashboardState();
}

class _DesktopDashboardState extends State<DesktopDashboard> {

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