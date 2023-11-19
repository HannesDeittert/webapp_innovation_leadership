import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:webapp_innovation_leadership/widget/map.dart';
import '../../widget/FilterWidgets/mainFilterUI.dart';


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