/*
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:webapp_innovation_leadership/datamanager/PDFRef.dart';

import 'User.dart';


class PDFRefProvider with ChangeNotifier{
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  List<PDFRef> _Refs = [];
  List<PDFRef> get PDFRefs => _Refs;
  String URL = "";
  String get getURL => URL;
  bool _RefdataLoaded = false;


  Future<void> loadPDFRefsFromFirestore() async {

    if (_RefdataLoaded) {
      print("returned as data is loaded");
      print("All already Loaded: $_Refs");
      return;
    }
    // Reference to the Firestore collection 'questions'
    CollectionReference questionsRef = FirebaseFirestore.instance.collection('PDFRef');

    // Load data from the collection
    QuerySnapshot snapshot = await questionsRef.get();
    print("UserSnapshot");
    print(snapshot);

    // Create Question objects from the Firestore documents
    _Refs = snapshot.docs.map((doc) {
      QueryDocumentSnapshot<Map<String, dynamic>> typedDoc = doc as QueryDocumentSnapshot<Map<String, dynamic>>;
      return PDFRef.fromFirestore(typedDoc);
    }).toList();
    print(_Refs);
    _RefdataLoaded = true;
    notifyListeners();
  }

  Future<void> updateDownloadURL(List<String> tags) async {
    CollectionReference questionsRef = FirebaseFirestore.instance.collection('PDFRef').where();

    URL = "";
    for (var pdfRef in _Refs) {
      if (pdfRef.chips == tags) {
          URL = pdfRef.ref;
          print(URL);
          notifyListeners();
      }
    }
    if (URL == ""){
      print("Nichts gefunden");
    }
  }
}*/
