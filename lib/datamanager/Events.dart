class HubEvents {
  final bool singledate;
  final String title;
  final String link;
  final List<String> daterange;
  final String date;
  final String uid;

  HubEvents({
    required this.uid,
    required this.date,
    required this.daterange,
    required this.link,
    required this.title,
    required this.singledate
  });
  factory HubEvents.fromFirestore(Map<String, dynamic> data) {
    return HubEvents(
      uid: data['uid'].toString(),
      title: data['title'].toString(),
      singledate: data['singledate'],
      link: data['link'].toString(),
      daterange: data['daterage'],
      date: data['date'].toString(),
    );
  }
}