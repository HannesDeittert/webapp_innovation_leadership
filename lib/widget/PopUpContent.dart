import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../home.dart';
import '../login/login_screen.dart';
import 'Sources & References.dart';

Widget PopUPContent(BuildContext context) {

  return Container(
    width: MediaQuery.of(context).size.width * 0.2,
    padding: EdgeInsets.all(16),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,

      children: [
        // Container 2
        Container(
          width: MediaQuery.of(context).size.width * 0.17,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            border: Border.all(),
          ),
          child: Column(
            children: [
              IconButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => LoginScreen()),
                    );
                  }, icon: Icon(Icons.login, color: Colors.black))
            ],
          ),
        ),
        Container(
          width: MediaQuery.of(context).size.width * 0.17,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            border: Border.all(),
          ),
          child: Column(
            children: [
              IconButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) =>Home()),
                    );
                  }, icon: Icon(Icons.home, color: Colors.black))
            ],
          ),
        ),

        SizedBox(
          height: 10,
        ),
        // Container 4
        Container(
          width: MediaQuery.of(context).size.width * 0.17,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            border: Border.all(),
          ),
          child: Column(
            children: [
              Text("General", style: TextStyle(fontWeight: FontWeight.bold),),
              // Textzeilen, die anklickbar sind
              buildClickableText(context,"Tips & Tricks"),
              buildClickableText(context,"About Us"),
              buildClickableText(context,"FAQs"),
              buildClickableText(context,"Sources & References"),
              buildClickableText(context,"Feedback"),
              buildClickableText(context,"Questions"),
            ],
          ),
        ),

        SizedBox(
          height: 10,
        ),

        // Container 5
        Container(
          width: MediaQuery.of(context).size.width * 0.17,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            border: Border.all(),
          ),
          child: Column(
            children: [
              // Hier den Code für das Development Impressum einfügen
              Text("Development Impressum", style: TextStyle(fontWeight: FontWeight.bold),),
              Text("Hannes Deittert"),
              Text("hannes.deittert@fau.de"),
              Text("Bohlenplatz 10 91054"),
              Text("Erlangen"),
            ],
          ),
        ),

      ],
    ),
  );
}

Widget buildClickableText(BuildContext context, String text) {
  return GestureDetector(
    onTap: () {
      if (text =="Sources & References"){
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => Sources()));
      }
    },
    child: Text(
      text,
      style: TextStyle(
        decoration: TextDecoration.underline,
        color: Colors.blue,
      ),
    ),
  );
}