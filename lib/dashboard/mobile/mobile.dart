import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:webapp_innovation_leadership/Constants/Colors.dart';
import '../../widget/header.dart';
import '../../widget/map.dart';


class MobileDashboard extends StatefulWidget {

  @override
  _MobileDashboardState createState() => _MobileDashboardState();
}

class _MobileDashboardState extends State<MobileDashboard> {

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