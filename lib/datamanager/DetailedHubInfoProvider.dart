

import 'dart:js';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:webapp_innovation_leadership/datamanager/InnovationHub.dart';
import '../widget/innovationhubdetailpage.dart';
import 'DetailedHubInfo.dart';

class DetailedHubInfoProvider with ChangeNotifier {
  late DetailedHubInfo _detailedInnovationHub;
  List<String> _Menu = [];
  List<String> Chips = [];

  List<String> get Menu => _Menu;

  DetailedHubInfo get detailedInnovationHub => _detailedInnovationHub;
  List<String> get getChips => Chips;

  void createChipList(List<String> chips) {
    Chips = chips;
    notifyListeners();
  }

  Future<DetailedHubInfo> getHubInfoByCode(String code,List<String> Filter) async {
    try {
      DetailedHubInfo load;

      DocumentReference detailedinnovationHubsRef = FirebaseFirestore.instance
          .collection('DetailedHubInfo').doc(code);

      // Daten aus der Sammlung laden
      DocumentSnapshot snapshot = await detailedinnovationHubsRef.get();

      String dcode = snapshot.get("code");
      String name = snapshot.get("name");

      String detailedDescription = snapshot.get("detailedDescription");

      String website = snapshot.get("website");

      String headerImage = snapshot.get("headerImage");

      String email_contact = snapshot.get("email_contact");


      String tele_contact = snapshot.get("tele_contact");

      List<dynamic> events_dynamic = snapshot.get("events");
      List<String> events = List<String>.from(events_dynamic);

      List<dynamic> work_dynamic = snapshot.get("work");
      List<String> work = List<String>.from(work_dynamic);
      List<String> filtered_chips = Filter;


      // InnovationHub-Objekt erstellen und zurückgeben
      load = DetailedHubInfo(
          code: dcode,
          name: name,
          detailedDescription: detailedDescription,
          website: website,
          headerImage: headerImage,
          email_contact: email_contact,
          tele_contact: tele_contact,
          events: events,
          work: work,
          filtered_chips: filtered_chips,
      );

      _detailedInnovationHub = load;
      return _detailedInnovationHub;

      // Dokument mit passendem Code gefunden
      //_detailedInnovationHub = DetailedHubInfo.fromFirestore(typedDoc);
      notifyListeners();
      print("Success!");
    } catch (error) {
      print('Error getting Innovation Hub: $error');
      return DetailedHubInfo(code: "code",
          name: "name",
          detailedDescription: "detailedDescription",
          website: "website",
          headerImage: "headerImage",
          email_contact: "email_contacts",
          tele_contact: "tele_contacts",
          events: ["events"],
          work: ["work"],
        filtered_chips: [],
      );

    }
  }

  Future<List<String>> getMenu() async {
    List<String> menu = [];
    print(detailedInnovationHub.tele_contact);
    print(detailedInnovationHub.work);

    if (detailedInnovationHub.detailedDescription.isNotEmpty) {
      menu.add("About");
    } if (detailedInnovationHub.work.isNotEmpty) {
      menu.add("Research");
    }if (detailedInnovationHub.events.isNotEmpty) {
      menu.add("Events");
    } if (detailedInnovationHub.tele_contact.isNotEmpty ||
        detailedInnovationHub.website.isNotEmpty) {
      menu.add("Contact");
    }
    print(menu);
    _Menu = menu;

    return menu;
  }
}

