

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

import 'Events.dart';

class EventProvider with ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  List<HubEvents> _Hubevents = [];
  List<HubEvents> _allHubevents = [];
  List<HubEvents> get Hubevents => _Hubevents;
  List<HubEvents> get allHubevents => _allHubevents;

  Future<List<HubEvents>> getEventListFromUidList(List<String> uidList) async {
    try {
      var querySnapshot = await _firestore.collection('events').where('uid', whereIn: uidList).get();

      _Hubevents = querySnapshot.docs.map((doc) {
        return HubEvents.fromFirestore(doc.data() as Map<String, dynamic>);
      }).toList();

      notifyListeners();

      return _Hubevents;
    } catch (e) {
      print('Error getting events for user: $e');
      return [];
    }
  }
  Future<void> loadAllEvents() async {
    try {
      var querySnapshot = await _firestore.collection('events').get();

      _allHubevents = querySnapshot.docs.map((doc) {
        return HubEvents.fromFirestore(doc.data() as Map<String, dynamic>);
      }).toList();

      notifyListeners();
    } catch (e) {
      print('Error loading all events: $e');
    }
  }
}