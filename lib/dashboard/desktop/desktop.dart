import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:webapp_innovation_leadership/Constants/Colors.dart';
import 'package:webapp_innovation_leadership/widget/InnoHubListWidget.dart';
import 'package:webapp_innovation_leadership/widget/header.dart';
import 'package:webapp_innovation_leadership/widget/map.dart';

import '../../datamanager/InnovationHub.dart';
import '../../widget/FilterWidgets/mainFilterUI.dart';
import '../../widget/Login.dart';
import '../../widget/MyListView.dart';

class DesktopDashboard extends StatefulWidget {
  @override
  _DesktopDashboardState createState() => _DesktopDashboardState();
}

class _DesktopDashboardState extends State<DesktopDashboard> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                Container(
                  height: (MediaQuery.of(context).size.height * (1 / 10)),
                  width: (MediaQuery.of(context).size.width * (1 / 5)),
                  child: OutlinedButton(
                    onPressed: () {
                      // Push the MainFilterUI route to the navigator stack
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => FilterUI()),
                      );
                    },
                    child: Text(
                      'Filter the Innovation Hubs',
                      style: TextStyle(color: Colors.white),
                    ),
                    style: OutlinedButton.styleFrom(
                      backgroundColor: Colors.black54,
                      shadowColor: Colors.grey,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: (MediaQuery.of(context).size.height * (1 / 5)),
                ),
                SizedBox(
                  width: (MediaQuery.of(context).size.width * (1 / 5)),
                  height: (MediaQuery.of(context).size.height * (2 / 3)),
                  child: InnoHubListWidget(),
                ),
              ],
            ),
          ),
          Padding(
              padding: const EdgeInsets.all(20),
              child: Container(
                height: MediaQuery.of(context).size.height,
                width: (MediaQuery.of(context).size.width * (3 / 4)),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: InnoMap(),
                ),
              )),
        ],
      ),
    ));
  }
}