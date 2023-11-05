import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:latlong2/latlong.dart';

import 'InnovationHub.dart';

class InnovationHubProvider with ChangeNotifier {
  List<InnovationHub> _innovationHubs = [];
  List<InnovationHub> _filteredHubs = [];
  bool _dataLoaded = false;  // Zustand, um den Ladezustand der Daten zu verfolgen

  List<InnovationHub> get innovationHubs => _innovationHubs;
  List<InnovationHub> get filteredHubs => _filteredHubs;
  bool get loaded => _dataLoaded;

  void createFilterdHubList(List<InnovationHub> filteredHubs) {
    _filteredHubs = filteredHubs;
    notifyListeners();
  }

  // Methode zum Laden der Innovation-Hubs aus Firestore
  Future<void> loadInnovationHubsFromFirestore() async {
    if (_dataLoaded) {
      print("returned as data is loaded");
      return;
    } // Wenn Daten bereits geladen wurden, kehren Sie sofort zurück

      // Referenz zur Firestore-Sammlung 'innovationHubs'
      CollectionReference innovationHubsRef = FirebaseFirestore.instance.collection('InnovationHubKollektion');

      // Daten aus der Sammlung laden
      QuerySnapshot snapshot = await innovationHubsRef.get();

      // Innovation-Hub-Objekte aus den Firestore-Dokumenten erstellen
      _innovationHubs = snapshot.docs.map((doc) {
        QueryDocumentSnapshot<Map<String, dynamic>> typedDoc = doc as QueryDocumentSnapshot<Map<String, dynamic>>;
        return InnovationHub.fromFirestore(typedDoc);
      }).toList();

      // Gefilterte Liste aktualisieren und Benachrichtigung senden
      _filteredHubs = _innovationHubs;
      _dataLoaded = true;
      print("Loaded once!"); // Setzen Sie _dataLoaded auf true, um anzuzeigen, dass die Daten geladen wurden
      print(_dataLoaded);
      notifyListeners();
    }
  }
