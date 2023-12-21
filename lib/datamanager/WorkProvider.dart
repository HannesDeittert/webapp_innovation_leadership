import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:webapp_innovation_leadership/datamanager/Work.dart';

import 'Events.dart';

class WorkProvider with ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  List<HubWork> _Hubworks = [];
  List<HubWork> _allHubworks = [];
  List<HubWork> get Hubworks => _Hubworks;
  List<HubWork> get allHubworks => _allHubworks;
  bool _HubworksdataLoaded = false;

  Future<List<HubWork>> getHubworksListFromUidList(List<String> uidList) async {
    try {
      List<HubWork> holder = [];
      for (String uid in uidList){
        holder.add(_allHubworks.firstWhere((element) => element.uid == uid));
      }
      _Hubworks = holder;
      notifyListeners();
      print("Workr:                        $_Hubworks");

      return _Hubworks;
    } catch (e) {
      print('Error getting events for user: $e');
      return [];
    }
  }
  Future<void> loadAllHubworks() async {

    if (_HubworksdataLoaded) {
      print("returned as Workdata is loaded");
      return;
    } // Wenn Daten bereits geladen wurden, kehren Sie sofort zurück

    CollectionReference HubworksRef = FirebaseFirestore.instance
        .collection('Work');

    /// Daten aus der Sammlung laden
    QuerySnapshot<Object?> snapshot = await HubworksRef.get();
    print(snapshot);

// Innovation-Hub-Objekte aus den Firestore-Dokumenten erstellen
    _allHubworks = snapshot.docs.map((doc) {
      QueryDocumentSnapshot<Map<String, dynamic>> typedDoc = doc as QueryDocumentSnapshot<Map<String, dynamic>>;
      return HubWork.fromFirestore(typedDoc.data());
    }).toList();

    _HubworksdataLoaded = true;
    notifyListeners();

  }
}