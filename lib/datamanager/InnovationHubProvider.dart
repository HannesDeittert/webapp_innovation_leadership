import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:latlong2/latlong.dart';

import 'InnovationHub.dart';

class InnovationHubProvider with ChangeNotifier {
  List<InnovationHub> _innovationHubs = [];
  List<InnovationHub> _filteredHubs = [];


  List<InnovationHub> get innovationHubs => _innovationHubs;
  List<InnovationHub> get filteredHubs => _filteredHubs;

  void createFilterdHubList(List<InnovationHub> filteredHubs) {
    _filteredHubs = filteredHubs;
    notifyListeners();
  }

  // Methode zum Laden der Innovation-Hubs aus Firestore
  Future<void> loadInnovationHubsFromFirestore() async {
    // Referenz zur Firestore-Sammlung 'innovationHubs'
    CollectionReference innovationHubsRef = FirebaseFirestore.instance.collection('InnovationHubKollektion');

    // Daten aus der Sammlung laden
    QuerySnapshot snapshot = await innovationHubsRef.get();
    print(snapshot);

    // Innovation-Hub-Objekte aus den Firestore-Dokumenten erstellen
    _innovationHubs = snapshot.docs.map((doc) {
      QueryDocumentSnapshot<Map<String, dynamic>> typedDoc = doc as QueryDocumentSnapshot<Map<String, dynamic>>;
      return InnovationHub.fromFirestore(typedDoc);
    }).toList();

    // Gefilterte Liste aktualisieren und Benachrichtigung senden
    _filteredHubs = _innovationHubs;
    notifyListeners();
  }
}