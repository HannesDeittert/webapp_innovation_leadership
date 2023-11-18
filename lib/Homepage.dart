import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:webapp_innovation_leadership/dashboard.dart';
import 'package:webapp_innovation_leadership/datamanager/QuestionProvider.dart';
import 'package:webapp_innovation_leadership/home.dart';
import 'package:webapp_innovation_leadership/side_menu_controller.dart';
import 'package:webapp_innovation_leadership/widget/FilterWidgets/mainFilterUI.dart';
import 'package:webapp_innovation_leadership/widget/responsive.dart';
import 'package:webapp_innovation_leadership/widget/side_menu.dart';

import 'datamanager/InnovationHub.dart';
import 'datamanager/InnovationHubProvider.dart';
import 'package:google_fonts/google_fonts.dart';


class MyHomePage extends StatelessWidget {
  final InnovationHubProvider provider = InnovationHubProvider();
  final QuestionProvider provider2 = QuestionProvider();
  bool isListViewSelected = true;


  @override
  void initState() {
    provider.loadInnovationHubsFromFirestore();
    provider2.loadQuestionsFromFirestore();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        leading: Image.asset("assets/images/FAU_INNOVATION_LOGO.png"),
        actions: [
          IconButton(onPressed: () {}, icon: Icon(Icons.login, color: Colors.black))
        ],
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width/30,vertical: 0.0 ),
        child: Container(
          child: Column(
            children: [
              SizedBox(height: MediaQuery.of(context).size.height/5),
              Container(
                padding: EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      children: [
                        Text(
                          'FAU',
                          style: GoogleFonts.lilitaOne(fontSize: 128,color: Color.fromARGB(0xFF, 0x55, 0x55, 0x55)),
                        ),
                        SizedBox(height: 5),
                        Column(
                            children: [
                            SizedBox(
                              height: MediaQuery.of(context).size.height/30,
                            ),
                            Text(
                            "Inno Hub",
                            style: GoogleFonts.pacifico(fontSize: 40,color: Color.fromARGB(0xFF, 0x55, 0x55, 0x55))
                          ),
                ]
                        )
                      ],
                    ),
                    Text(
                      'Discover our innovation facilities and become \na part of the FAU innovation journey',
                      style: TextStyle(fontSize: 50,color: Color.fromARGB(0xFF, 0x55, 0x55, 0x55)),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20),
              Row(
                      children: [

                        TextButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => FilterUI()),
                            );
                            // Aktion für den weißen Button mit schwarzer Umrandung
                          },
                          style: TextButton.styleFrom(
                              backgroundColor: Color.fromARGB(0xFF, 0x0F, 0x62, 0xFE),
                              side: BorderSide(color: Colors.black),
                              fixedSize: Size(MediaQuery.of(context).size.width/9, MediaQuery.of(context).size.height/30)
                          ),
                          child: Text(
                            'Personal Reccomendations',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                            ),
                          ),
                        ),
                        SizedBox(
                          width: MediaQuery.of(context).size.width/80,
                        ),
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
                            fixedSize: Size(MediaQuery.of(context).size.width/20, MediaQuery.of(context).size.height/30)
                          ),
                          child: Text(
                            'View All',
                            style: TextStyle(
                              color: Color.fromARGB(0xFF, 0x55, 0x55, 0x55),
                              fontSize: 20,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
        ),
      ),
          );
  }
}
