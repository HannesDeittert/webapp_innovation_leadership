import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:webapp_innovation_leadership/AdminPanels/SuperAdminPanel.dart';
import 'package:webapp_innovation_leadership/datamanager/InnovationHub.dart';
import 'package:webapp_innovation_leadership/datamanager/InnovationHubProvider.dart';

import '../AdminPanels/AdminPanel.dart';
import '../AdminPanels/HubPanel.dart';
import '../AdminPanels/Unassigned_hub.dart';
import '../Homepage.dart';
import '../datamanager/UserProvider.dart';
import 'RegisterScreen.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  final UserProvider provider = UserProvider();
  bool obscureText = true;

  final String imagePath = 'Images/FAU_INNOVATION_LOGO.png';

  Future<Widget> _loadLeadingImage() async {
    try {
      final ref = firebase_storage.FirebaseStorage.instance.ref(imagePath);
      final url = await ref.getDownloadURL();

      // Load the image from the URL
      final imageWidget = Image.network(url);

      // You can adjust the size of the image by using a `Container` wrapper
      return Container(
        width: 100,  // Change this as needed
        height: 100,  // Change this as needed
        child: imageWidget,
      );
    } catch (e) {
      print('Error loading image: $e');
      // You can return a default image or show an error message here
      return Image.asset('assets/placeholder_image.jpg'); // Example of a default image
    }
  }

  Future<void> signIn(List<InnovationHub> all) async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(
          email: emailController.text,
          password: passwordController.text);

      print("Login successful: ${userCredential.user?.uid}");
      await UserProvider().loadUserFromFirestore();

      String? userRole = await UserProvider().getUserRole(userCredential.user!.uid);

      if (userRole != null) {
        print("User Role: $userRole");

        if (userRole == "super") {
          await provider.loadUserFromFirestore();

          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => SuperAdminPanel()),
          );
        } else if(userRole == "Admin"){
          await provider.loadUserFromFirestore();
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AdminPanel()),
          );
        } else if(userRole == "HubAdmin"){
          String? userHub = await UserProvider().getAdminHub(userCredential.user!.uid);
          InnovationHub hub = all.firstWhere(
                (hub) => hub.code == userHub,
            orElse: () => throw StateError('No hub found with code $userHub'),
          );
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => HubPanel(hub)),
          );
        } else if(userRole == "unassigned"){
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => unassigned_hub()),
          );
        }
      }
    } on FirebaseAuthException catch (e) {
      print("Login failed: $e");

      String errorMessage;

      switch (e.code) {
        case 'user-not-found':
          errorMessage = 'Benutzer nicht gefunden. Überprüfen Sie Ihre Eingaben.';
          break;
        case 'wrong-password':
          errorMessage = 'Falsches Passwort. Bitte versuchen Sie es erneut.';
          break;
        case 'invalid-email':
          errorMessage = 'Ungültige E-Mail-Adresse. Bitte geben Sie eine gültige E-Mail-Adresse ein.';
          break;
        default:
          errorMessage = 'Anmeldung fehlgeschlagen. Bitte überprüfen Sie Ihre Eingaben und versuchen Sie es erneut.';
          break;
      }

      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Error during login'),
          content: Text(errorMessage),
          actions: [
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        ),
      );

      print("Error message: $errorMessage");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Consumer<InnovationHubProvider>(
        builder: (context, provider, child) {
          List<InnovationHub> all = provider.allinnovationHubs;

          return Center(
            child: Column(
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border(
                      bottom: BorderSide(
                        width: 1,
                        color: Color.fromARGB(0xFF, 0x55, 0x55, 0x55),
                      ),
                    ),
                  ),
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: MediaQuery.of(context).size.width / 30,
                      vertical: 0.0,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        FutureBuilder(
                          future: _loadLeadingImage(),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.done) {
                              return snapshot.data!;
                            } else if (snapshot.hasError) {
                              return Icon(Icons.error);
                            } else {
                              return CircularProgressIndicator();
                            }
                          },
                        ),
                        IconButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => MyHomePage(),
                              ),
                            );
                          },
                          icon: Icon(Icons.home, color: Colors.black),
                        ),
                      ],
                    ),
                  ),
                ),
                Spacer(),
                Container(
                  width: MediaQuery.of(context).size.width / 4,
                  height: MediaQuery.of(context).size.height / 2,
                  child: Column(
                    children: [
                      TextField(
                        controller: emailController,
                        decoration: InputDecoration(labelText: 'Email'),
                      ),
                      TextField(
                        controller: passwordController,
                        decoration: InputDecoration(
                          labelText: 'Password',
                          suffixIcon: IconButton(
                            icon: Icon(
                              obscureText
                                  ? Icons.visibility_off
                                  : Icons.visibility,
                            ),
                            onPressed: () {
                              setState(() {
                                obscureText = !obscureText;
                              });
                            },
                          ),
                        ),
                        obscureText: obscureText,
                      ),
                      SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: () => signIn(all),
                        child: Text('Sign In'),
                      ),
                      SizedBox(height: 10),
                      TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => RegisterScreen(),
                            ),
                          );
                        },
                        child: Text(
                          'Don\'t have an account? Register here.',
                        ),
                      ),
                    ],
                  ),
                ),
                Spacer(),
              ],
            ),
          );
        },
      ),
    );
  }
}
