
class MyUser {
  final String uid;
  final String email;
  final String role;
  final String hub;

  MyUser({
    required this.uid,
    required this.email,
    required this.role,
    required this.hub,
  });
  factory MyUser.fromFirestore(Map<String, dynamic> data) {
    return MyUser(
      uid: data['uid'].toString(),
      email: data['email'].toString(),
      role: data['role'].toString(),
      hub: data['hub'].toString(),
    );
  }
}