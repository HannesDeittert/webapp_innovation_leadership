// Datei: detailed_hub_info.dart

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class DetailedHubInfo {
  final String code;
  final String name;
  final String detailedDescription;
  final String headerImage;
  final String website;
  final List<String> email_contacts;
  final List<String> tele_contacts;


  DetailedHubInfo({
    required this.code,
    required this.name,
    required this.detailedDescription,
    required this.website,
    required this.headerImage,
    required this.email_contacts,
    required this.tele_contacts,
  });
  static DetailedHubInfo fromFirestore(QueryDocumentSnapshot<Map<String, dynamic>> documentSnapshot) {
    // Eigenschaften aus dem Dokument extrahieren
    Map<String, dynamic> data = documentSnapshot.data();
    String code = data["code"];
    String name = data["name"];
    String detailedDescription = data["detailedDescription"];
    String website = data["website"];
    String headerImage = data["headerImage"];
    List<String> email_contacts = data["email_contacts"];
    List<String> tele_contacts = data["tele_contacts"];


    // InnovationHub-Objekt erstellen und zurückgeben
    return DetailedHubInfo(
      code: code,
      name: name,
      detailedDescription: detailedDescription,
      website: website,
      headerImage: headerImage,
      email_contacts: email_contacts,
      tele_contacts: tele_contacts,
    );
  }
}
