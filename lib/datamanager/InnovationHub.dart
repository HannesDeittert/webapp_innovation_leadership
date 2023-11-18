
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:latlong2/latlong.dart';

class InnovationHub {
  final LatLng coordinates;
  final String category;
  final String name;
  final String summary;
  final List<String> question_category;
  final List<String> question_goal;
  final List<String> question_topic;
  final String code;


  InnovationHub({
    required this.coordinates,
    required this.category,
    required this.name,
    required this.summary,
    required this.question_category,
    required this.question_goal,
    required this.question_topic,
    required this.code,
  });
  // Statischer Konstruktor zum Erstellen eines InnovationHub-Objekts aus einem Firestore-Dokument
  static InnovationHub fromFirestore(QueryDocumentSnapshot<Map<String, dynamic>> documentSnapshot) {
    // Eigenschaften aus dem Dokument extrahieren
    Map<String, dynamic> data = documentSnapshot.data();
    double latitude = data['latitude'];
    double longitude = data['longitude'];
    LatLng coordinates = LatLng(latitude, longitude); // LatLng-Objekt erstellen
    String category = data['category'];
    String name = data['name'];
    String summary = data['summary'];
    List<String> question_category = List<String>.from(data['question_category']);
    List<String> question_goal = List<String>.from(data['question_goal']);
    List<String> question_topic = List<String>.from(data['question_topic']);
    String code = data['code'];

    // InnovationHub-Objekt erstellen und zurückgeben
    return InnovationHub(
      coordinates: coordinates,
      category: category,
      name: name,
      summary: summary,
      question_category: question_category,
      question_topic: question_topic,
      question_goal: question_goal,
      code: code,
    );
  }
}

