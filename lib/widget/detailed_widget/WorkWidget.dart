import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:webapp_innovation_leadership/Constants/Colors.dart';
import '../../datamanager/Work.dart';
import 'package:responsive_builder/responsive_builder.dart';

import '../../datamanager/WorkProvider.dart';
import '../ResearchListItem.dart';

class WorkWidget extends StatelessWidget {
  final List<HubWork> workList;
  final String name;
  final bool detail;

  WorkWidget(this.workList, this.name, this.detail);

  @override
  Widget build(BuildContext context) {
    WorkProvider provider4 = Provider.of<WorkProvider>(context);
    List<HubWork> Research = provider4.Hubworks;
    // Ansonsten eine ListView mit ExpansionTiles erstellen
    return detail ? Container(
      color: tBackground,
      width: MediaQuery.of(context).size.width *(1156/1512),
      padding: EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "This are all Research fields from $name",
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w700,
              color: tPrimaryColorText,
            ),
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.02,
          ),
          ListView.builder(
              shrinkWrap: true,
              itemCount: Research.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: EdgeInsets.symmetric(vertical: 8.0),
                  child: ResearchListItem(Work: Research[index], Lenght: (MediaQuery.of(context).size.width * (1095/1512)),detail: false, ),
                );
              }
          ),
        ],
      ),
    ) : Container(
      color: tBackground,
      width: MediaQuery.of(context).size.width *(1156/1512),
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
          ListView.builder(
              shrinkWrap: true,
              itemCount: Research.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: EdgeInsets.symmetric(vertical: 8.0),
                  child: ResearchListItem(Work: Research[index], Lenght: (MediaQuery.of(context).size.width * (1095/1512)),detail: true, ),
                );
              }
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
