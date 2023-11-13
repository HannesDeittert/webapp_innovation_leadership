import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:webapp_innovation_leadership/dashboard.dart';
import 'package:webapp_innovation_leadership/datamanager/QuestionProvider.dart';
import 'package:webapp_innovation_leadership/home.dart';
import 'package:webapp_innovation_leadership/side_menu_controller.dart';
import 'package:webapp_innovation_leadership/widget/responsive.dart';
import 'package:webapp_innovation_leadership/widget/side_menu.dart';

import 'datamanager/InnovationHub.dart';
import 'datamanager/InnovationHubProvider.dart';


class MyHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        leading: Image.asset("assets/images/FAU_INNOVATION_LOGO.png"),
        actions: [
          IconButton(onPressed: () {}, icon: Icon(Icons.login, color: Colors.black))
        ],
      ),
      body: Container(
        color: Colors.white,
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              children: [
                Text(
                  'FAU',
                  style: TextStyle(fontSize: 300, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 5),
                Column(

                  children: [
                    SizedBox(
                      height: 100,
                    ),
                    Text(
                    "Innovation",
                    style: TextStyle(fontSize: 100, fontWeight: FontWeight.bold)
                  ),
        ]
                )
              ],
            ),
            Text(
              'Discover our innovation facilitys and become \na part of the FAU innovation journey.',
              style: TextStyle(fontSize: 50),
            ),
            SizedBox(height: 20),
            Row(
              children: [
                OutlinedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => Home()),
                    );
                    // Aktion für den weißen Button mit schwarzer Umrandung
                  },
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(color: Colors.black),
                  ),
                  child: Text(
                    'Let`s go!',
                    style: TextStyle(
                        color: Colors.black,
                      fontSize: 60,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
