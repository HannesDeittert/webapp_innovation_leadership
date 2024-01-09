import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:url_launcher/url_launcher.dart';
import 'package:webapp_innovation_leadership/Constants/Colors.dart';
import '../../datamanager/Work.dart';
import 'package:responsive_builder/responsive_builder.dart';

class WorkWidget extends StatelessWidget {
  final List<HubWork> workList;
  final String name;

  WorkWidget(this.workList, this.name);

  @override
  Widget build(BuildContext context) {
    // Wenn es nur ein Event gibt, direkt die EventPage anzeigen
    if (workList.length == 1) {
      Uri link = Uri(
          scheme: 'https',
          path: workList[0].link
      );
      return Container(
        color: Colors.white,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Date: ${workList[0].date}"),
            SizedBox(height: 8.0),
            Text("Description: ${workList[0].shortdescription}"),
            SizedBox(height: 8.0),
            buildLinkText(link,workList[0].link),
            SizedBox(height: 8.0),
            Text("Tags: ${workList[0].tags.join(", ")}"),
          ],
        ),
      );
    }

    // Ansonsten eine ListView mit ExpansionTiles erstellen
    return Container(
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
              itemCount: workList.length,
              itemBuilder: (context, index) => WorkListItem(work: workList[index]),
            ),
          ),
        ],
      ),
    );
  }
}

class WorkListItem extends StatelessWidget {
  final HubWork work;

  WorkListItem({required this.work});

  @override
  Widget build(BuildContext context) {
    Uri link = Uri(
        scheme: 'https',
        path: work.link
    );
    print(link);
    return ExpansionTile(
      title: Text(work.title),
      subtitle: Text(work.date),
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Description: ${work.longdescription}"),
              SizedBox(height: 8.0),
              buildLinkText(link, work.link),
              SizedBox(height: 8.0),
              Text("Tags: ${work.tags.join(", ")}"),
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
