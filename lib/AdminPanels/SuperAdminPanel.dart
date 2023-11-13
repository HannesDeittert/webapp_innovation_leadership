import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SuperAdminPanel extends StatefulWidget {
  const SuperAdminPanel({Key? key}) : super(key: key);

  @override
  _SuperAdminPanelState createState() => _SuperAdminPanelState();
}

class _SuperAdminPanelState extends State<SuperAdminPanel> {
  late User _user;

  @override
  void initState() {
    super.initState();
    _user = FirebaseAuth.instance.currentUser!;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Super Admin Panel'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Welcome, Super Admin!'),
            SizedBox(height: 20),
            Text('User ID: ${_user.uid}'),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                // Hier fügst du Aktionen hinzu, die Super Admin durchführen kann
              },
              child: Text('Perform Super Admin Action'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                // Hier fügst du die Aktion zum Abmelden hinzu
                await FirebaseAuth.instance.signOut();
                // Optional: Du kannst den Benutzer dann zu einer anderen Seite navigieren
              },
              child: Text('Sign Out'),
            ),
          ],
        ),
      ),
    );
  }
}