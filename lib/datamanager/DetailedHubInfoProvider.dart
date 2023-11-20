

import 'dart:js';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../widget/innovationhubdetailpage.dart';
import 'DetailedHubInfo.dart';

class DetailedHubInfoProvider with ChangeNotifier {
  late DetailedHubInfo _detailedInnovationHub;

  DetailedHubInfo get detailedInnovationHub => _detailedInnovationHub;

  Future<void> getHubInfoByCode(String code) async {
    try {
      DetailedHubInfo load;

      DocumentReference detailedinnovationHubsRef = FirebaseFirestore.instance.collection('DetailedHubInfo').doc(code);

      // Daten aus der Sammlung laden
      DocumentSnapshot snapshot = await detailedinnovationHubsRef.get();

      String dcode = snapshot.get("code");
      String name = snapshot.get("name");

      String detailedDescription = snapshot.get("detailedDescription");

      String website = snapshot.get("website");

      String headerImage = snapshot.get("headerImage");

      List<dynamic> email_contacts_dynamic =  snapshot.get("email_contacts") ;
      List<String> email_contacts = List<String>.from(email_contacts_dynamic);

      List<dynamic> tele_contacts_dynamic = snapshot.get("tele_contacts");
      List<String> tele_contacts = List<String>.from(tele_contacts_dynamic);


      // InnovationHub-Objekt erstellen und zurückgeben
      load=  DetailedHubInfo(
        code: dcode,
        name: name,
        detailedDescription: detailedDescription,
        website: website,
        headerImage: headerImage,
        email_contacts: email_contacts,
        tele_contacts: tele_contacts,
      );

      _detailedInnovationHub = load;

      // Dokument mit passendem Code gefunden
      //_detailedInnovationHub = DetailedHubInfo.fromFirestore(typedDoc);
      notifyListeners();
      print("Success!");

    } catch (error) {
      print('Error getting Innovation Hub: $error');
    }
  }
}

