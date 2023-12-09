// Datei: detailed_hub_info.dart

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class DetailedHubInfo {
  final String code;
  final String name;
  final String detailedDescription;
  final String headerImage;
  final String website;
  final String email_contact;
  final String tele_contact;
  final List<String> events;
  final List<String> work;



  DetailedHubInfo({
    required this.code,
    required this.name,
    required this.detailedDescription,
    required this.website,
    required this.headerImage,
    required this.email_contact,
    required this.tele_contact,
    required this.work,
    required this.events,
  });
  static DetailedHubInfo fromFirestore(QueryDocumentSnapshot<Map<String, dynamic>> documentSnapshot) {
    // Eigenschaften aus dem Dokument extrahieren
    Map<String, dynamic> data = documentSnapshot.data();
    String code = data["code"];
    String name = data["name"];
    String detailedDescription = data["detailedDescription"];
    String website = data["website"];
    String headerImage = data["headerImage"];
    String email_contact = data["email_contact"];
    String tele_contact = data["tele_contact"];
    List<String> events = data["events"];
    List<String> work = data["work"];


    // InnovationHub-Objekt erstellen und zurückgeben
    return DetailedHubInfo(
      code: code,
      name: name,
      detailedDescription: detailedDescription,
      website: website,
      headerImage: headerImage,
      email_contact: email_contact,
      tele_contact: tele_contact,
      events: events,
      work: work
    );
  }
}
