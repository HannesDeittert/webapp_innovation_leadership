import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:webapp_innovation_leadership/AdminPanels/SuperAdminPanel.dart';
import 'package:webapp_innovation_leadership/CommunityPages/Community.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../Constants/Colors.dart';
import '../Events.dart';
import '../Homepage.dart';
import '../InnovationGuide.dart';
import '../InnovationHubs.dart';
import '../datamanager/DetailedHubInfoProvider.dart';
import '../datamanager/EventProvieder.dart';
import '../datamanager/UserProvider.dart';
import '../datamanager/WorkProvider.dart';
import 'RegisterScreen.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool isHomeViewSelected = false;
  bool isHubViewSelected = false;
  bool isEventViewSelected = false;
  bool isGuideViewSelected = false;
  bool isCommunityViewSelected = true;
  bool isDetailedViewSelected = false;
  final UserProvider provider = UserProvider();
  bool obscureText = true;

  @override
  void initState() {
    super.initState();
    // Überprüfe den Authentifizierungsstatus beim Initialisieren der Seite
    checkLoggedInUser();
  }

  // Überprüfe, ob der Benutzer bereits eingeloggt ist
  void checkLoggedInUser() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      // Benutzer ist bereits eingeloggt, leite ihn weiter
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => Community()),
      );
    }
  }

  final String imagePath = 'Images/FAU_INNOVATION_LOGO.png';

  Future<Widget> _loadLeadingImage(width, height) async {
    try {
      final ref = firebase_storage.FirebaseStorage.instance.ref(imagePath);
      final url = await ref.getDownloadURL();

      // Lade das Bild von der URL
      final imageWidget = Image.network(url);

      // Du kannst die Größe des Bildes anpassen, indem du eine `Container`-Umgebung verwendest
      return Container(
        width: width * 0.03248, // Ändere dies nach Bedarf
        height: height * 0.05, // Ändere dies nach Bedarf
        child: imageWidget,
      );
    } catch (e) {
      print('Fehler beim Laden des Bildes: $e');
      // Hier könntest du ein Standardbild zurückgeben oder eine Fehlermeldung anzeigen
      return Image.asset(
          'assets/placeholder_image.jpg'); // Beispiel für ein Standardbild
    }
  }


  Future<void> signIn() async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(
          email: emailController.text,
          password: passwordController.text);

      print("Login successful: ${userCredential.user?.uid}");
      await UserProvider().loadUserFromFirestore();

      String? userRole = await UserProvider().getUserRole(userCredential.user!.uid);
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => Community()),
      );

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
      backgroundColor: tBackground,
      body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.0155,
            ),
            Container(
              decoration: BoxDecoration(
                  color: tBackground,
                  border: Border(
                    bottom: BorderSide(
                        width: 1,
                        color:  tBackground),
                  )
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width/30,vertical: 0.0 ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [

                    GestureDetector(
                      onTap: (){
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => MyHomePage(),
                          ),
                        );
                      },
                      child: Row(
                        children: [
                          FutureBuilder(
                            future: _loadLeadingImage(MediaQuery.of(context).size.width,MediaQuery.of(context).size.height),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState == ConnectionState.done) {
                                // Wenn das Bild geladen wurde, zeige es an
                                return snapshot.data!;
                              } else if (snapshot.hasError) {
                                // Wenn ein Fehler aufgetreten ist, zeige eine Fehlermeldung an
                                return Icon(Icons.error); // Hier könntest du eine andere Fehleranzeige verwenden
                              } else {
                                // Ansonsten zeige einen Ladeindikator oder ein Platzhalterbild an
                                return CircularProgressIndicator();
                              }
                            },
                          ),
                          Text("fau innohub",style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600
                          ),)
                        ],
                      ),
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width*0.455,
                      height: MediaQuery.of(context).size.height*0.062,
                      decoration: BoxDecoration(
                          color: tWhite,
                          borderRadius: BorderRadius.circular(MediaQuery.of(context).size.height*0.031,)
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          GestureDetector(
                            onTap: (){
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => InnovationHubs(),
                              ),
                            );
                          },
                            child: Text(
                              "Innovation hubs",
                              style: TextStyle(
                                  fontWeight: isHubViewSelected
                                      ? FontWeight.w700
                                      : FontWeight.w500,
                                  fontSize: 16),
                            ),
                          ),
                          GestureDetector(
                            onTap: () async {
                              // Den DetailedHubInfoProvider vom Kontext abrufen
                              DetailedHubInfoProvider detailedHubInfoProvider = Provider.of<DetailedHubInfoProvider>(context, listen: false);
                              EventProvider provider3 = Provider.of<EventProvider>(context, listen:  false);
                              WorkProvider provider4 = Provider.of<WorkProvider>(context, listen:  false);
                              // _detailedHubInfo über die loadDetailedHubInfo-Methode initialisieren
                              await provider3.loadAllEvents();
                              await provider4.loadAllHubworks();
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => EventsHome()),
                              );
                            },
                            child: Text(
                              "Events",
                              style: TextStyle(
                                  fontWeight: isEventViewSelected
                                      ? FontWeight.w700
                                      : FontWeight.w500,
                                  fontSize: 16),
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => GuideHome()),
                              );
                            },
                            child: Text(
                              "Innovation Guide",
                              style: TextStyle(
                                  fontWeight: isGuideViewSelected ?FontWeight.w700: FontWeight.w500,
                                  fontSize: 16
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => LoginScreen()),
                              );
                            },
                            child: Text(
                              "Community",
                              style: TextStyle(
                                  fontWeight: isCommunityViewSelected ?FontWeight.w700: FontWeight.w500,
                                  fontSize: 16
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      width: 0,
                    )
                  ],
                ),
              ),
            ),
            SizedBox(
              height: 8,
            ),
            Expanded(
              child: Center(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Text(
                      'Log In/Create Account to be part of our Community',
                      style: TextStyle(fontSize: 32,fontWeight: FontWeight.w400),
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width * 0.392,
                      height: MediaQuery.of(context).size.height * 0.6395,
                      decoration: BoxDecoration(
                        color: tWhite,
                        borderRadius: BorderRadius.circular(30),
                      ),
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
                            onPressed: () => signIn(),
                            child: Text('Sign In'),
                          ),
                          SizedBox(height: 10),
                          /*ElevatedButton(
                            onPressed: () => signInWithGoogle(),
                            child: Text('Sign In with Google'),
                          ),*/
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
                  ],
                ),
              ),
            )
          ]),
    );
  }
}
