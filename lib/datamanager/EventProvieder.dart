

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

import 'Events.dart';

class EventProvider with ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  List<HubEvents> _Hubevents = [];
  List<HubEvents> _allHubevents = [];
  List<HubEvents> get Hubevents => _Hubevents;
  List<HubEvents> get allHubevents => _allHubevents;
  bool _eventdataLoaded = false;

  Future<List<HubEvents>> getEventListFromUidList(List<String> uidList) async {
    print(uidList);
    print(_allHubevents);
    try {
      List<HubEvents> holder = [];
      for (String uid in uidList){
        holder.add(_allHubevents.firstWhere((element) => element.uid == uid));
      }
      _Hubevents = holder;
      notifyListeners();
      print("Events: $_Hubevents");

      return _Hubevents;
    } catch (e) {
      print('Error getting events for user: $e');
      return [];
    }
  }
  Future<void> loadAllEvents() async {

      if (_eventdataLoaded) {
        print("returned as data is loaded");
        return;
      } // Wenn Daten bereits geladen wurden, kehren Sie sofort zurück

      CollectionReference EventsRef = FirebaseFirestore.instance
          .collection('Events');

      /// Daten aus der Sammlung laden
      QuerySnapshot<Object?> snapshot = await EventsRef.get();
      print(snapshot);

// Innovation-Hub-Objekte aus den Firestore-Dokumenten erstellen
    _allHubevents = snapshot.docs.map((doc) {
      QueryDocumentSnapshot<Map<String, dynamic>> typedDoc = doc as QueryDocumentSnapshot<Map<String, dynamic>>;
      return HubEvents.fromFirestore(typedDoc.data());
    }).toList();
      print(_allHubevents);

      _eventdataLoaded = true;
      print(
          "Loaded once!"); // Setzen Sie _dataLoaded auf true, um anzuzeigen, dass die Daten geladen wurden
      print("Event $_eventdataLoaded");
      notifyListeners();

  }
}