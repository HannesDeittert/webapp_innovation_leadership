import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<User?> signInWithEmailAndPassword(String email, String password) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(email: email, password: password);
      User? user = userCredential.user;

      // Check if the user is a SuperAdmin
      DocumentSnapshot userDoc = await _firestore.collection('users').doc(user?.uid).get();
      Map<String, dynamic>? userData = userDoc.data() as Map<String, dynamic>?;
      bool isSuperAdmin = userData?['isSuperAdmin'] ?? false;

      // Return the user if the authentication was successful
      return user;
    } catch (e) {
      print(e);
      return null;
    }
  }
}