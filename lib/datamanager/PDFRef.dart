import 'package:cloud_firestore/cloud_firestore.dart';

class PDFRef {
  final List<String> chips;
  final String ref;


  PDFRef({
    required this.chips,
    required this.ref,
  });
  static PDFRef fromFirestore(QueryDocumentSnapshot<Map<String, dynamic>> documentSnapshot) {
    Map<String, dynamic> data = documentSnapshot.data();

    print(data);
    List<String> chips = List<String>.from(data['chips']);

    return PDFRef(
      ref: data['ref'].toString(),
      chips: chips,
    );
  }
}