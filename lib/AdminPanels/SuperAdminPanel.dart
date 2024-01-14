import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:webapp_innovation_leadership/Homepage.dart';
import 'package:webapp_innovation_leadership/datamanager/User.dart';
import '../datamanager/InnovationHubProvider.dart';
import '../datamanager/QuestionProvider.dart';
import '../datamanager/UserProvider.dart';
import '../widget/AdminPanelWidgets/InnoHubList.dart';
import '../widget/AdminPanelWidgets/UserList.dart';

class SuperAdminPanel extends StatefulWidget {
  const SuperAdminPanel({Key? key}) : super(key: key);

  @override
  _SuperAdminPanelState createState() => _SuperAdminPanelState();
}

class _SuperAdminPanelState extends State<SuperAdminPanel> {
  late User _user;
  late List<MyUser> users;
  final InnovationHubProvider provider = InnovationHubProvider();

  final UserProvider provider3 = UserProvider();
  bool isUpdateGeneral = true;
  bool isUpdateDetailed = false;




  @override
  void initState() {
    super.initState();
    users = provider3.user;
    print(users);
    _user = FirebaseAuth.instance.currentUser!;
    provider.loadInnovationHubsFromFirestore();

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
    bool isUserViewSelected = true;
    bool isHubViewSelected = false;
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
                  mainAxisSize: MainAxisSize.min,
                  children: [
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
                              child: Row(
                                children: [
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "Intereact with the InnovationHubs and users",
                                        style: TextStyle(
                                            fontSize: 18,
                                            color:
                                            Color.fromARGB(0xFF, 0x55, 0x55, 0x55)),
                                      ),
                                      SizedBox(
                                        height: 20,
                                      ),
                                      // Buttons to switch between ListView and MapView
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        children: [
                                          OutlinedButton(
                                            onPressed: () {
                                              setState(() {
                                                isUserViewSelected = true;
                                                isHubViewSelected = false;
                                              });
                                            },
                                            child: Row(
                                              children: [
                                                Icon(
                                                  Icons.circle_outlined,
                                                  color: Colors.black,
                                                ),
                                                Padding(
                                                  padding: const EdgeInsets.symmetric(
                                                      horizontal: 10, vertical: 10),
                                                  child: Text(
                                                    'UserView',
                                                    style: TextStyle(
                                                        color: Color.fromARGB(
                                                            0xFF, 0x55, 0x55, 0x55)),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            style: ButtonStyle(
                                              backgroundColor:
                                              MaterialStateProperty.all(
                                                  isUserViewSelected
                                                      ? Color.fromARGB(
                                                      0xFF, 0xDD, 0xE1, 0xE6)
                                                      : Colors.white),
                                            ),
                                          ),
                                          OutlinedButton(
                                            onPressed: () {
                                              setState(() {
                                                isUserViewSelected = false;
                                                isHubViewSelected = false;
                                              });
                                            },
                                            child: Row(
                                              children: [
                                                Icon(
                                                  Icons.circle_outlined,
                                                  color: Colors.black,
                                                ),
                                                Padding(
                                                  padding: const EdgeInsets.symmetric(
                                                      horizontal: 10, vertical: 10),
                                                  child: Text(
                                                    'HubView',
                                                    style: TextStyle(
                                                        color: Color.fromARGB(
                                                            0xFF, 0x55, 0x55, 0x55)),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            style: ButtonStyle(
                                              backgroundColor:
                                              MaterialStateProperty.all(
                                                  isHubViewSelected
                                                      ? Color.fromARGB(
                                                      0xFF, 0xDD, 0xE1, 0xE6)
                                                      : Colors.white),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),

                                  Spacer(),
                                ],
                              ),
                            ),
                            // Display either ListView or MapView based on selection
                          ],
                        ),
                      ),
                    ),
                    Flexible(
                      fit: FlexFit.loose,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: isUserViewSelected
                            ? UserList()
                            : AdminInnoHubList(),
                      ),
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
