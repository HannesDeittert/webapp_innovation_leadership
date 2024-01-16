import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:provider/provider.dart';
import 'package:webapp_innovation_leadership/Homepage.dart';
import 'package:webapp_innovation_leadership/datamanager/DetailedHubInfo.dart';
import 'package:webapp_innovation_leadership/datamanager/DetailedHubInfoProvider.dart';
import 'package:webapp_innovation_leadership/datamanager/InnovationHub.dart';
import 'package:webapp_innovation_leadership/widget/AdminPanelWidgets/UpdateInnoHub_General.dart';
import '../datamanager/InnovationHubProvider.dart';
import '../widget/AdminPanelWidgets/UpdateInnoHub_Detailed.dart';

//This is the HubPanel:
// if an HubAdmin logs in, this is the page the user gets pushed to
// Admins and SuperAdmins can Access this Page when they click on the icon on there HubList in the main Admin Window



class HubPanel extends StatefulWidget {
  final InnovationHub hub;

  const HubPanel(this.hub, {Key? key}) : super(key: key);

  @override
  _HubPanelState createState() => _HubPanelState();
}

class _HubPanelState extends State<HubPanel> {
  late User _user;
  late InnovationHub _hub;
  late DetailedHubInfo _detailed;
  bool isUpdateGeneral = true;
  bool isUpdateDetailed = false;

  @override
  void initState() {
    super.initState();
    _user = FirebaseAuth.instance.currentUser!;
    _hub = widget.hub;
    DetailedHubInfoProvider().getHubInfoByCode(widget.hub.code,[]).then((detailedInfo) {
      setState(() {
        _detailed = detailedInfo;
      });
    });
  }

  final String imagePath = 'Images/FAU_INNOVATION_LOGO.png';

  Future<Widget> _loadLeadingImage() async {
    try {
      final ref = firebase_storage.FirebaseStorage.instance.ref(imagePath);
      final url = await ref.getDownloadURL();

      // Load the image from the URL
      final imageWidget = Image.network(url);

      // Adjust the size of the image using a `Container` wrapper
      return Container(
        width: 100,  // Change this as needed
        height: 100,  // Change this as needed
        child: imageWidget,
      );
    } catch (e) {
      print('Error loading image: $e');
      // Return a default image or show an error message
      return Image.asset('assets/placeholder_image.jpg'); // Example of a default image
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Consumer<InnovationHubProvider>(
        builder: (context, provider, child) {
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
                            if (snapshot.connectionState == ConnectionState.done) {
                              // If the image is loaded, show it
                              return snapshot.data!;
                            } else if (snapshot.hasError) {
                              // If an error occurred, show an error icon
                              return Icon(Icons.error);
                            } else {
                              // Otherwise, show a loading indicator or a placeholder image
                              return CircularProgressIndicator();
                            }
                          },
                        ),
                        Column(
                          children: [
                            Text('Welcome, Hub Admin!'),
                            SizedBox(height: 20),
                            Text('User ID: ${_user.uid}'),
                          ],
                        ),
                        IconButton(
                          onPressed: () async {
                            await FirebaseAuth.instance.signOut();
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => MyHomePage()),
                            );
                          },
                          icon: Icon(Icons.logout, color: Colors.black),
                        ),
                      ],
                    ),
                  ),
                ),
                Container(
                  color: Colors.white,
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: MediaQuery.of(context).size.width / 30,
                      vertical: 0.0,
                    ),
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
                                    "Update this Innovation Hub",
                                    style: TextStyle(
                                      fontSize: 18,
                                      color: Color.fromARGB(0xFF, 0x55, 0x55, 0x55),
                                    ),
                                  ),
                                  SizedBox(height: 20),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      OutlinedButton(
                                        onPressed: () {
                                          setState(() {
                                            isUpdateDetailed = true;
                                            isUpdateGeneral = false;
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
                                                horizontal: 10,
                                                vertical: 10,
                                              ),
                                              child: Text(
                                                'UpdateDetailed',
                                                style: TextStyle(
                                                  color: Color.fromARGB(0xFF, 0x55, 0x55, 0x55),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        style: ButtonStyle(
                                          backgroundColor: MaterialStateProperty.all(
                                            isUpdateDetailed
                                                ? Color.fromARGB(0xFF, 0xDD, 0xE1, 0xE6)
                                                : Colors.white,
                                          ),
                                        ),
                                      ),
                                      OutlinedButton(
                                        onPressed: () {
                                          setState(() {
                                            isUpdateDetailed = false;
                                            isUpdateGeneral = true;
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
                                                horizontal: 10,
                                                vertical: 10,
                                              ),
                                              child: Text(
                                                'MapView',
                                                style: TextStyle(
                                                  color: Color.fromARGB(0xFF, 0x55, 0x55, 0x55),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        style: ButtonStyle(
                                          backgroundColor: MaterialStateProperty.all(
                                            isUpdateGeneral
                                                ? Color.fromARGB(0xFF, 0xDD, 0xE1, 0xE6)
                                                : Colors.white,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  child: isUpdateGeneral
                      ? UpdateInnoHub_General(_hub)
                      : UpdateInnoHub_Detailed(_detailed),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}