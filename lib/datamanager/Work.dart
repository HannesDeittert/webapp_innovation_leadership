class HubWork {
  final String title;
  final String link;
  final List<String> tags;
  final String shortdescription;
  final String longdescription;
  final String TitleImage;
  final String TextImage;
  final String date;
  final String uid;

  HubWork({
    required this.uid,
    required this.date,
    required this.tags,
    required this.shortdescription,
    required this.longdescription,
    required this.TitleImage,
    required this.TextImage,
    required this.link,
    required this.title,

  });
  factory HubWork.fromFirestore(Map<String, dynamic> data) {
    return HubWork(
      uid: data['uid'].toString(),
      title: data['title'].toString(),
      tags: List<String>.from(data['tags']),
      longdescription: data['longdescription'],
      shortdescription: data['shortdescription'],
        TitleImage: data['TitleImage'],
      TextImage: data['TextImage'],
      link: data['link'].toString(),
      date: data['date'].toString(),
    );
  }
}