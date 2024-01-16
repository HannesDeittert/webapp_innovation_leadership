import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:latlong2/latlong.dart';
import 'InnovationHub.dart';

class InnovationHubProvider with ChangeNotifier {
  List<InnovationHub> _innovationHubs = [];
  List<InnovationHub> _allinnovationHubs = [];
  List<InnovationHub> _recomendations = [];
  List<InnovationHub> _filteredHubs = [];
  bool _dataLoaded = false; // Zustand, um den Ladezustand der Daten zu verfolgen

  List<InnovationHub> get innovationHubs => _innovationHubs;

  List<InnovationHub> get allinnovationHubs => _allinnovationHubs;

  List<InnovationHub> get recomendations => _recomendations;

  List<InnovationHub> get filteredHubs => _filteredHubs;

  InnovationHub getInnovationHubByCode(String code) {
    return _innovationHubs.firstWhere((hub) => hub.code == code,);
  }

  bool get loaded => _dataLoaded;

  void createFilterdHubList(List<InnovationHub> filteredHubs) {
    _filteredHubs = filteredHubs;
    notifyListeners();
  }
  InnovationHub? findHubByCoordinates(LatLng coordinates) {
    try {
      return _innovationHubs.firstWhere(
            (hub) => hub.coordinates == coordinates,
      );
    } catch (e) {
      return null; // Return null if no matching hub is found
    }
  }


  // Methode zum Laden der Innovation-Hubs aus Firestore
  Future<void> loadInnovationHubsFromFirestore() async {
    if (_dataLoaded) {
      print("returned as data is loaded");
      return;
    } // Wenn Daten bereits geladen wurden, kehren Sie sofort zurück

    // Referenz zur Firestore-Sammlung 'innovationHubs'
    CollectionReference innovationHubsRef = FirebaseFirestore.instance
        .collection('InnovationHubKollektion');

    // Daten aus der Sammlung laden
    QuerySnapshot snapshot = await innovationHubsRef.get();

    // Innovation-Hub-Objekte aus den Firestore-Dokumenten erstellen
    _allinnovationHubs = snapshot.docs.map((doc) {
      QueryDocumentSnapshot<Map<String, dynamic>> typedDoc = doc as QueryDocumentSnapshot<Map<String, dynamic>>;
      return InnovationHub.fromFirestore(typedDoc);
    }).toList();


    // Filter _allinnovationhubs so that _innovationHubs only contains hubs with status "live"
    _innovationHubs =
        _allinnovationHubs.where((hub) => hub.status == "live").toList();
    //_innovationHubs = _allinnovationHubs;


    // Gefilterte Liste aktualisieren und Benachrichtigung senden
    _filteredHubs = _innovationHubs;
    _dataLoaded = true;
    print(
        "Loaded once!"); // Setzen Sie _dataLoaded auf true, um anzuzeigen, dass die Daten geladen wurden
    print(_dataLoaded);
    print(_filteredHubs);
    notifyListeners();
  }
  void calculate_recomendations(InnovationHub hub) {
    // Get the original list of innovation hubs
    List<InnovationHub> originalHubs = innovationHubs;
    List<InnovationHub> recohold = innovationHubs;
    List<Map<InnovationHub, int>> filteredHubs = [];
      for (InnovationHub Hub in originalHubs) {
        int matchCount = 0;
        // Calculate simmilarity for allSelectedItems_goal
        for (String tag in hub.question_goal) {
          if (Hub.question_goal.contains(tag)) {
            matchCount++;
          }
        }
        // Calculate simmilarity for allSelectedItems_topic
        for (String tag in hub.question_topic) {
          if (Hub.question_topic.contains(tag)) {
            matchCount++;
          }
        }
        // Calculate simmilarity for allSelectedItems_category
        for (String tag in hub.question_category) {
          if (Hub.question_category.contains(tag)) {
            matchCount++;
          }
        }
        // Add it to filtered Hubs
        filteredHubs.add({Hub: matchCount});
      }
      print(filteredHubs);

      // Sort filteredHubs by matchCount
      filteredHubs.sort((a, b) => b.values.first.compareTo(a.values.first));

      // Cut Hubs with 0 matchCount
      filteredHubs.removeWhere((entry) => entry.values.first == 0);


    if (filteredHubs.length > 3) {
      filteredHubs = filteredHubs.sublist(0, 3);
    }
      // Create a List<InnovationHub> from the sorted List<Map>
      recohold = filteredHubs.map((entry) =>
      entry.keys.first).toList();
    recohold.removeWhere((element) => element == hub);
    _recomendations = recohold;
    print(_recomendations.length);
    notifyListeners();
    }
  }
