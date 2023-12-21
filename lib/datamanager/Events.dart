class HubEvents {
  final bool singledate;
  final String title;
  final String link;
  final List<String> tags;
  final String description;
  final List<String> daterange;
  final String date;
  final String uid;

  HubEvents({
    required this.uid,
    required this.date,
    required this.daterange,
    required this.tags,
    required this.description,
    required this.link,
    required this.title,
    required this.singledate
  });
  factory HubEvents.fromFirestore(Map<String, dynamic> data) {
    return HubEvents(
      uid: data['uid'].toString(),
      title: data['title'].toString(),
      singledate: data['singledate'],
      tags: List<String>.from(data['tags']),
      description: data['description'],
      link: data['link'].toString(),
      daterange: List<String>.from(data['daterange']),
      date: data['date'].toString(),
    );
  }
}