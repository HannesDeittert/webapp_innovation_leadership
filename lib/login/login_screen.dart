import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:webapp_innovation_leadership/AdminPanels/SuperAdminPanel.dart';

import '../datamanager/UserProvider.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  Future<void> signIn() async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(
          email: emailController.text,
          password: passwordController.text);

      print("Login successful: ${userCredential.user?.uid}");

      // Hier kannst du die Navigation oder andere Aktionen nach dem erfolgreichen Login durchführen
      // Beispiel: Rolle abrufen
      String? userRole =
      await UserProvider().getUserRole(userCredential.user!.uid);

      if (userRole != null) {
        print("User Role: $userRole");

        // Hier kannst du je nach Rolle unterschiedliche Aktionen durchführen
        if (userRole == "super") {
          // Öffne die Admin-Seite
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => SuperAdminPanel()),
          );
          // Navigator.push(context, MaterialPageRoute(builder: (context) => AdminPage()));
        } else if(userRole == "Admin"){
          // Öffne die Standardseite für andere Rollen
          // Navigator.push(context, MaterialPageRoute(builder: (context) => OtherPage()));
        } else if(userRole == "HubAdmin"){
        // Öffne die Standardseite für andere Rollen
        // Navigator.push(context, MaterialPageRoute(builder: (context) => OtherPage()));
      } else if(userRole == "User"){
        // Öffne die Standardseite für andere Rollen
        // Navigator.push(context, MaterialPageRoute(builder: (context) => OtherPage()));
      }
      }
    } on FirebaseAuthException catch (e) {
      print("Login failed: ${e.message}");
      // Hier kannst du Fehlerbehandlung durchführen, z.B. Fehlermeldung anzeigen
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: emailController,
              decoration: InputDecoration(labelText: 'Email'),
            ),
            TextField(
              controller: passwordController,
              decoration: InputDecoration(labelText: 'Password'),
              obscureText: true,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: signIn,
              child: Text('Sign In'),
            ),
            SizedBox(height: 10),
            TextButton(
              onPressed: () {
                // Hier kannst du zur Registrierungsseite navigieren
              },
              child: Text('Don\'t have an account? Register here.'),
            ),
          ],
        ),
      ),
    );
  }
}