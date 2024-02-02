
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

import 'Events.dart';

class EventProvider with ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  late HubEvents selectedEvent;
  List<HubEvents> _Hubevents = [];
  List<HubEvents> _filteredHubevents = [];
  List<Appointment> _filteredAppointment = [];
  List<HubEvents> _allHubevents = [];
  HubEvents get selHubevent => selectedEvent;
  List<HubEvents> get Hubevents => _Hubevents;
  List<Appointment> get filteredAppointment => _filteredAppointment;
  List<HubEvents> get allHubevents => _allHubevents;
  List<HubEvents> get filteredEvents => _filteredHubevents;
  bool _eventdataLoaded = false;

  void createFilterdEventList(List<HubEvents> filteredHubevents_) {
    _filteredHubevents = filteredHubevents_;
    createFilterdAppointmentList(_filteredHubevents);
    notifyListeners();
  }

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

  Future<void> selectEvent(HubEvents Event) async{
    selectedEvent = Event;
    notifyListeners();
  }

  void createFilterdAppointmentList(List<HubEvents> filteredHubevents_) {
    _filteredAppointment = filteredHubevents_.map((event) {
      return Appointment(
        startTime: event.startTime,
        endTime: event.endTime,
        subject: event.title,
        notes: event.description,
        isAllDay: event.allday,
        recurrenceId: event,
      );
    }).toList();

    notifyListeners();
  }

  Future<void> loadAllEvents() async {

      if (_eventdataLoaded) {
        print("returned as data is loaded");
        print("All already Loaded: $_allHubevents");
        print("All Filtered already Loaded: $_filteredHubevents");
        return;
      } // Wenn Daten bereits geladen wurden, kehren Sie sofort zurück

      CollectionReference EventsRef = FirebaseFirestore.instance
          .collection('Events');

      /// Daten aus der Sammlung laden
      QuerySnapshot<Object?> snapshot = await EventsRef.where('HubCode', isNotEqualTo: "Prod").get();
      print(snapshot);

// Innovation-Hub-Objekte aus den Firestore-Dokumenten erstellen
    _allHubevents = snapshot.docs.map((doc) {
      QueryDocumentSnapshot<Map<String, dynamic>> typedDoc = doc as QueryDocumentSnapshot<Map<String, dynamic>>;
      return HubEvents.fromFirestore(typedDoc.data());
    }).toList();
      print("All: $_allHubevents");

      _filteredHubevents = _allHubevents;
      createFilterdAppointmentList(_filteredHubevents);
      _eventdataLoaded = true;
      print(
          "Loaded once!"); // Setzen Sie _dataLoaded auf true, um anzuzeigen, dass die Daten geladen wurden
      print("Event $_eventdataLoaded");
      notifyListeners();

  }
}