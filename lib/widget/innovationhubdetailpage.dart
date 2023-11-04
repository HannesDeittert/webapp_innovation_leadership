import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:webapp_innovation_leadership/datamanager/DetailedHubInfo.dart';

import '../datamanager/DetailedHubInfoProvider.dart';
import '../datamanager/InnovationHub.dart';

class InnovationHubDetailPage extends StatefulWidget {


  @override
  _InnovationHubDetailPageState createState() => _InnovationHubDetailPageState();
}

class _InnovationHubDetailPageState extends State<InnovationHubDetailPage> {
  late InnovationHub hub;

  @override
  Widget build(BuildContext context) {
    // Zugriff auf den InnovationHubProvider
    DetailedHubInfoProvider provider = Provider.of<DetailedHubInfoProvider>(context);

    // Liste der gefilterten Hubs abrufen
    DetailedHubInfo Info = provider.detailedHubInfo;
    return Scaffold(
      appBar: AppBar(
        title: Text(Info.name),
      ),
      body: Column(
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.height/10,
            width: MediaQuery.of(context).size.width,
            child: Image.asset(
              Info.headerImage,
              fit: BoxFit.fitHeight,
            )
          ),
          Text(Info.detailedDescription),
          // ... Weitere Informationen für den InnovationHub anzeigen
        ],
      ),
    );
  }
}