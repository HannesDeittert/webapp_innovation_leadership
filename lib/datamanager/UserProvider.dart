import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

import 'User.dart';


class UserProvider with ChangeNotifier{
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  List<MyUser> _user = [];
  List<MyUser> get user => _user;

  Future<void> createUser(String uid, String email, String role) async {
    await _firestore.collection('users').doc(uid).set({
      'email': email,
      'role': role,
    });
  }

  Future<void> adInnoHub(String uid, String code) async {
    await _firestore.collection('users').doc(uid).set({
      'hub': code,
    });
  }

  Future<void> deleteUser(String uid) async {
    await _firestore.collection('users').doc(uid).delete();
  }

  Future<void> changeUserRole(String uid, String newRole) async {
    await _firestore.collection('users').doc(uid).update({
      'role': newRole,
    });
  }

  Future<String?> getUserRole(String uid) async {
    try {
      var documentSnapshot =
      await _firestore.collection('users').doc(uid).get();
      if (documentSnapshot.exists) {
        return documentSnapshot['role'];
      }
      return null;
    } catch (e) {
      print('Error getting user role: $e');
      return null;
    }
  }
  Future<String?> getAdminHub(String uid) async {
    try {
      var documentSnapshot =
      await _firestore.collection('users').doc(uid).get();
      if (documentSnapshot.exists) {
        return documentSnapshot['hub'];
      }
      return null;
    } catch (e) {
      print('Error getting user role: $e');
      return null;
    }
  }
  Future<void> loadUserFromFirestore() async {
    // Reference to the Firestore collection 'questions'
    CollectionReference questionsRef = FirebaseFirestore.instance.collection('users');

    // Load data from the collection
    QuerySnapshot snapshot = await questionsRef.get();
    print("UserSnapshot");
    print(snapshot);

    // Create Question objects from the Firestore documents
    _user = snapshot.docs.map((doc) {
      QueryDocumentSnapshot<Map<String, dynamic>> typedDoc = doc as QueryDocumentSnapshot<Map<String, dynamic>>;
      return MyUser.fromFirestore(typedDoc.data());
    }).toList();
    print(_user);

    notifyListeners();
  }

}