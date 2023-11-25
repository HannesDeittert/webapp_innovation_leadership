import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:webapp_innovation_leadership/Homepage.dart';
import '../datamanager/InnovationHubProvider.dart';
import '../datamanager/QuestionProvider.dart';

class SuperAdminPanel extends StatefulWidget {
  const SuperAdminPanel({Key? key}) : super(key: key);

  @override
  _SuperAdminPanelState createState() => _SuperAdminPanelState();
}

class _SuperAdminPanelState extends State<SuperAdminPanel> {
  late User _user;
  final InnovationHubProvider provider = InnovationHubProvider();
  final QuestionProvider provider2 = QuestionProvider();
  bool isUpdateGeneral = true;
  bool isUpdateDetailed = false;

  @override
  void initState() {
    super.initState();
    _user = FirebaseAuth.instance.currentUser!;
    provider.loadInnovationHubsFromFirestore();
    provider2.loadQuestionsFromFirestore();
  }
  final String imagePath = 'Images/FAU_INNOVATION_LOGO.png';

  Future<Widget> _loadLeadingImage() async {
    try {
      final ref = firebase_storage.FirebaseStorage.instance.ref(imagePath);
      final url = await ref.getDownloadURL();
      final imageWidget = Image.network(url);

      return Container(
        width: 100,
        height: 100,
        child: imageWidget,
      );
    } catch (e) {
      print('Fehler beim Laden des Bildes: $e');
      return Image.asset('assets/placeholder_image.jpg');
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
                padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width/30,vertical: 0.0 ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    FutureBuilder(
                      future: _loadLeadingImage(),
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
                    Column(children: [
                      Text('Welcome, Super Admin!'),
                      SizedBox(height: 20),
                      Text('User ID: ${_user.uid}'),
                    ],),
                    IconButton(
                        onPressed: () async {
                          await FirebaseAuth.instance.signOut();
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => MyHomePage()),

                          );
                        }, icon: Icon(Icons.logout, color: Colors.black))
                  ],
                ),
              ),
            ),
            Container(
              color: Colors.white,
              child: Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: MediaQuery.of(context).size.width / 30,
                    vertical: 0.0),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 20),
                      child: Column(
                        children: [
                          Container(
                            width: MediaQuery.of(context).size.width / 1.5,
                            height: MediaQuery.of(context).size.height/2,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5),
                                border: Border.all(width: 3)
                            ),
                            child: Text("Manage Hubs"),
                            ///ToDo: Gets a list of _allInnovationHubs
                            /// Implement a logic to display the Hubs in a list view, and allow Admin to change status to live, archieved, inProgress
                            /// Implement a logic to navigate the Admin to the HubPanel
                          ),
                          Container(
                            width: MediaQuery.of(context).size.width / 1.5,
                            height: MediaQuery.of(context).size.height/2,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5),
                                border: Border.all(width: 3)
                            ),
                            child: Text("Manage Users"),

                            ///ToDo: Gets a list of all Users with role: Admin and HubAdmin and unassigned
                            /// Implement a logic to display the Users in a list view, and allow Admin to change role to Admin; Superadmin; unassigned; HubAdmin
                            /// if changed to Hub admin denkt daran, dass auch der jeweilige Hub.code Hinzugefügt werden können muss.
                          ),
                        ],
                      )
                    ),
                    // Display either ListView or MapView based on selection
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
