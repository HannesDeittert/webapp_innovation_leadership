import 'dart:js';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:webapp_innovation_leadership/datamanager/Events.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../Constants/Colors.dart';

class EventWidget extends StatelessWidget {
  final List<HubEvents> events;
  final String name;


  EventWidget(this.events, this.name);

  @override
  Widget build(BuildContext context) {
    // Wenn es nur ein Event gibt, direkt die EventPage anzeigen
    if (events.length == 1) {
      Uri link = Uri(
          scheme: 'https',
          path: events[0].link
      );
      return Container(
          color: Colors.white,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Date: ${events[0].singledate ? events[0].date : "${events[0].daterange[0]} - ${events[0].daterange[1]}"}"),
              SizedBox(height: 8.0),
              Text("Description: ${events[0].description}"),
              SizedBox(height: 8.0),
              buildLinkText(link,events[0].link),
              SizedBox(height: 8.0),
              Text("Tags: ${events[0].tags.join(", ")}"),
            ],
          ),
      );
    }

    // Ansonsten eine ListView mit ExpansionTiles erstellen
    return Container(
      color: Colors.white,
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
              itemBuilder: (context, index) => EventListItem(event: events[index]),
            ),
          ),
        ],
      ),
    );
  }
}

class EventListItem extends StatelessWidget {
  final HubEvents event;

  EventListItem({required this.event});

  @override
  Widget build(BuildContext context) {
    Uri link = Uri(
        scheme: 'https',
        path: event.link
    );
    print(link);
    return ExpansionTile(
      title: Text(event.title),
      subtitle: event.singledate ? Text(event.date) : Text("${event.daterange[0]} - ${event.daterange[1]}"),
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Description: ${event.description}"),
              SizedBox(height: 8.0),
              buildLinkText(link, event.link),
              SizedBox(height: 8.0),
              Text("Tags: ${event.tags.join(", ")}"),
            ],
          ),
        ),
      ],
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