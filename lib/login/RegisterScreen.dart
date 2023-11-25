import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:webapp_innovation_leadership/Homepage.dart';
import 'package:webapp_innovation_leadership/datamanager/UserProvider.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import '../AdminPanels/Unassigned_hub.dart';

class RegisterScreen extends StatefulWidget {
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();
  bool obscureText = true;
  final String imagePath = 'Images/FAU_INNOVATION_LOGO.png';

  Future<Widget> _loadLeadingImage() async {
    try {
      final ref = firebase_storage.FirebaseStorage.instance.ref(imagePath);
      final url = await ref.getDownloadURL();

      // Lade das Bild von der URL
      final imageWidget = Image.network(url);

      // Du kannst die Größe des Bildes anpassen, indem du eine `Container`-Umgebung verwendest
      return Container(
        width: 100,  // Ändere dies nach Bedarf
        height: 100,  // Ändere dies nach Bedarf
        child: imageWidget,
      );
    } catch (e) {
      print('Fehler beim Laden des Bildes: $e');
      // Hier könntest du ein Standardbild zurückgeben oder eine Fehlermeldung anzeigen
      return Image.asset('assets/placeholder_image.jpg'); // Beispiel für ein Standardbild
    }
  }


  Future<void> signUp() async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
        email: emailController.text,
        password: passwordController.text,
      );
      //ToDo: use Method vom UserProvider to create User in firebase Collection and assign the role: unassigned
      await UserProvider().createUser(
        userCredential.user!.uid,
        emailController.text,
        "unassigned",
      );

      print("Registration successful: ${userCredential.user?.uid}");
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => unassigned_hub()),
      );

      // Hier kannst du nach der Registrierung weitere Aktionen durchführen
      // z.B. den Benutzer mit einer Rolle in der Datenbank verknüpfen
    } on FirebaseAuthException catch (e) {
      print("Registration failed: ${e.code}");

      String errorMessage;

      switch (e.code) {
        case 'email-already-in-use':
          errorMessage = 'Diese E-Mail-Adresse wird bereits verwendet. Bitte verwenden Sie eine andere.';
          break;
        case 'invalid-email':
          errorMessage = 'Ungültige E-Mail-Adresse. Bitte geben Sie eine gültige E-Mail-Adresse ein.';
          break;
        case 'weak-password':
          errorMessage = 'Das Passwort ist zu schwach. Bitte wählen Sie ein stärkeres Passwort.';
          break;
        default:
          errorMessage = 'Registrierung fehlgeschlagen. Bitte überprüfen Sie Ihre Eingaben und versuchen Sie es erneut.';
          break;
      }

      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Fehler bei der Registrierung'),
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
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
            children: [
              Container(
                decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border(
                      bottom: BorderSide(
                          width: 1,
                          color: Color.fromARGB(0xFF, 0x55, 0x55, 0x55)),
                    )
                ),
                child: Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: MediaQuery.of(context).size.width / 30,
                      vertical: 0.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      FutureBuilder(
                        future: _loadLeadingImage(),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.done) {
                            // Wenn das Bild geladen wurde, zeige es an
                            return snapshot.data!;
                          } else if (snapshot.hasError) {
                            // Wenn ein Fehler aufgetreten ist, zeige eine Fehlermeldung an
                            return Icon(Icons
                                .error); // Hier könntest du eine andere Fehleranzeige verwenden
                          } else {
                            // Ansonsten zeige einen Ladeindikator oder ein Platzhalterbild an
                            return CircularProgressIndicator();
                          }
                        },
                      ),
                      IconButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => MyHomePage()),
                            );
                          },
                          icon: Icon(Icons.home, color: Colors.black))
                    ],
                  ),
                ),
              ),
              Spacer(),
              Container(
                width: MediaQuery.of(context).size.width / 4,
                height: MediaQuery.of(context).size.height / 2,
                child:
                Column(
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
                            obscureText ? Icons.visibility_off : Icons.visibility,
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
                    TextField(
                      controller: confirmPasswordController,
                      decoration: InputDecoration(
                        labelText: 'Confirm Password',
                        suffixIcon: IconButton(
                          icon: Icon(
                            obscureText ? Icons.visibility_off : Icons.visibility,
                          ),
                          onPressed: () {
                            setState(() {
                              obscureText = !obscureText;
                            });
                          },
                        ),              ),
                      obscureText: obscureText,
                    ),

                    SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () {
                        if (passwordController.text == confirmPasswordController.text) {
                          // Passwörter stimmen überein, führe die Registrierung durch
                          signUp();
                        } else {
                          // Passwörter stimmen nicht überein, zeige eine Fehlermeldung an
                          print("Passwords do not match");
                          // Hier kannst du eine Fehlermeldung anzeigen
                        }
                      },
                      child: Text('Sign Up'),
                    ),
                  ],
                ),
              ),
              Spacer(),

            ],
          ),
      ),
    );
  }
}