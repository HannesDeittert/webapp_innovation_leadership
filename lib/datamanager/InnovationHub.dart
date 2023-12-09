
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:latlong2/latlong.dart';

class InnovationHub {
  final LatLng coordinates;
  final String category;
  final String status;
  final String name;
  final String summary;
  final List<String> question_category;
  final List<String> question_goal;
  final List<String> question_topic;
  final String code;
  final String profileImagePath;
  final List<String> filtered_chips;


  InnovationHub({
    required this.coordinates,
    required this.category,
    required this.status,
    required this.name,
    required this.summary,
    required this.question_category,
    required this.question_goal,
    required this.question_topic,
    required this.code,
    required this.profileImagePath,
    required this.filtered_chips,
  });
  // Statischer Konstruktor zum Erstellen eines InnovationHub-Objekts aus einem Firestore-Dokument
  static InnovationHub fromFirestore(QueryDocumentSnapshot<Map<String, dynamic>> documentSnapshot) {
    // Eigenschaften aus dem Dokument extrahieren
    Map<String, dynamic> data = documentSnapshot.data();
    double latitude = data['latitude'] as double;
    double longitude = data['longitude'] as double;
    LatLng coordinates = LatLng(latitude, longitude); // LatLng-Objekt erstellen
    String category = data['category'];
    String status = data['status'];
    String name = data['name'];
    String summary = data['summary'];
    List<String> question_category = List<String>.from(data['question_category']);
    List<String> question_goal = List<String>.from(data['question_goal']);
    List<String> question_topic = List<String>.from(data['question_topic']);
    String code = data['code'];
    String profileImagePath = data['profileImagePath'];
    List<String> filtered_chips = [];

    // InnovationHub-Objekt erstellen und zurückgeben
    return InnovationHub(
      coordinates: coordinates,
      category: category,
      status: status,
      name: name,
      summary: summary,
      question_category: question_category,
      question_topic: question_topic,
      question_goal: question_goal,
      code: code,
      profileImagePath: profileImagePath,
      filtered_chips: filtered_chips,
    );
  }
}
