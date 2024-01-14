import 'package:cloud_firestore/cloud_firestore.dart';

class HubEvents {
  final bool allday;
  final bool free;
  final String title;
  final String link;
  final String eventImagePath;
  final List<String> tags;
  final List<String> Type;
  final String description;
  final DateTime startTime;
  final DateTime endTime;
  final String uid;
  final String HubCode;
  final bool fau;
  final List<String> filtered_chips;

  HubEvents({
    required this.uid,
    required this.free,
    required this.endTime,
    required this.startTime,
    required this.tags,
    required this.eventImagePath,
    required this.Type,
    required this.description,
    required this.link,
    required this.title,
    required this.fau,
    required this.HubCode,
    required this.allday,
    required this.filtered_chips,
  });
  factory HubEvents.fromFirestore(Map<String, dynamic> data) {
    List<String> filtered_chips = [];
    DateTime convertTimestamp(Timestamp timestamp) {
      return timestamp.toDate();
    }
    return HubEvents(
      uid: data['uid'].toString(),
      title: data['title'].toString(),
      free:  data['free'],
      allday: data['allday'],
      tags: List<String>.from(data['tags']),
      Type: List<String>.from(data['Type']),
      description: data['description'],
      link: data['link'].toString(),
      fau: data['fau'],
      HubCode: data['HubCode'],
      eventImagePath: data['eventImagePath'].toString(),
      endTime: convertTimestamp(data['endTime']),
      startTime: convertTimestamp(data['startTime']),
      filtered_chips: filtered_chips,
    );
  }
}