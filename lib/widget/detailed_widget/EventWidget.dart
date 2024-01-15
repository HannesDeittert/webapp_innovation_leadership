import 'dart:js';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:webapp_innovation_leadership/datamanager/Events.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../Constants/Colors.dart';
import '../EventListItem.dart';

class EventWidget extends StatelessWidget {
  final List<HubEvents> events;
  final String name;


  EventWidget(this.events, this.name);

  @override
  Widget build(BuildContext context) {
    // Ansonsten eine ListView mit ExpansionTiles erstellen
    return
      Container(
        width: MediaQuery.of(context).size.width *(1156/1512),
        color: tBackground,
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "This are all Events from $name!",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w700,
                color: tPrimaryColorText,
              ),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.02,
            ),
            Expanded(
              child: ListView.builder(
                itemCount: events.length,
                itemBuilder: (context, index) => EventListItem(Event: events[index], Lenght: (MediaQuery.of(context).size.width * (1095/1512)),detail: false, ),),
              ),
          ],
        ),
    );
  }
}

Widget buildLinkText(Uri link, String linkstring) {
  // Erstelle einen klickbaren Link
  final recognizer = TapGestureRecognizer()
    ..onTap = () async {
      _launchInBrowser(link);
    };

  return RichText(
    text: TextSpan(
      text: 'Link: ',
      children: [
        TextSpan(
          text: linkstring,
          style: TextStyle(
            color: Colors.blue,
            decoration: TextDecoration.underline,
          ),
          recognizer: recognizer,
        ),
      ],
    ),
  );
}

Future<void> _launchInBrowser(Uri url) async {
  if (!await launchUrl(
    url,
    mode: LaunchMode.externalApplication,
  )) {
    throw Exception('Could not launch $url');
  }
}