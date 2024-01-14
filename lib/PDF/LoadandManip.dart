import 'dart:html';
import 'dart:typed_data';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';


/// Represents Homepage for Navigation
class InnovationGuide  {
  // Create a storage reference from our app
  final storageRef = FirebaseStorage.instance.ref();
  late PdfDocument document;
  Uint8List? _documentBytes;

  void getPdfBytes() async {
    firebase_storage.Reference pdfRef = FirebaseStorage.instance.ref('pdf/Exercise_2.pdf');
    print('Ref: $pdfRef');
    //size mentioned here is max size to download from firebase.
    try {
      const oneMegabyte = 1024 * 1024;
      _documentBytes = await pdfRef.getData(oneMegabyte);

      document = PdfDocument(inputBytes: _documentBytes);
      document.pages.removeAt(0);
      print('Tset');

      List<int> bytes =await document.save();

    } on FirebaseException catch (e){
      print(e);
    }
  }


}
