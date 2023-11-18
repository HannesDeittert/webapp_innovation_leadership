import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:webapp_innovation_leadership/dashboard.dart';
import 'package:webapp_innovation_leadership/datamanager/QuestionProvider.dart';
import 'package:webapp_innovation_leadership/side_menu_controller.dart';
import 'package:webapp_innovation_leadership/widget/FilterWidgets/mainFilterUI.dart';
import 'package:webapp_innovation_leadership/widget/InnoHubListWidget.dart';
import 'package:webapp_innovation_leadership/widget/MyListView.dart';
import 'package:webapp_innovation_leadership/widget/map.dart';
import 'package:webapp_innovation_leadership/widget/responsive.dart';
import 'package:webapp_innovation_leadership/widget/side_menu.dart';

import 'datamanager/InnovationHub.dart';
import 'datamanager/InnovationHubProvider.dart';
import 'login/login_screen.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {

  bool isListViewSelected = true;




  @override
  Widget build(BuildContext context) {
    Color listViewButtonColor =
    isListViewSelected ? Colors.grey : Colors.white;
    Color mapViewButtonColor =
    !isListViewSelected ? Colors.grey : Colors.white;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        leading: Image.asset("assets/images/FAU_INNOVATION_LOGO.png"),
        actions: [
          IconButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => LoginScreen()),
                );
              }, icon: Icon(Icons.login, color: Colors.black))
        ],
      ),
      body: Center(
        child: Container(
          color: Colors.white,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Row(
                  children: [
                      Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              isListViewSelected
                                  ? 'This is the ListView of all Innovation Hubs'
                                  : 'This is the MapView of all Innovation Hubs',
                              style: TextStyle(fontSize: 18),
                            ),
                          ),
                          // Buttons to switch between ListView and MapView
                          // Buttons to switch between ListView and MapView
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              OutlinedButton(
                                onPressed: () {
                                  setState(() {
                                    isListViewSelected = true;
                                  });
                                },
                                child: Row(
                                  children: [
                                    Icon(Icons.list,
                                    color: Colors.black,),
                                    Text('ListView',
                                    style: TextStyle(
                                      color: Colors.black
                                    ),),
                                  ],
                                ),
                                style: ButtonStyle(
                                  backgroundColor: MaterialStateProperty.all(listViewButtonColor),
                                ),
                              ),
                              OutlinedButton(
                                onPressed: () {
                                  setState(() {
                                    isListViewSelected = false;
                                  });
                                },
                                child: Row(
                                  children: [
                                    Icon(Icons.map_outlined,
                                    color: Colors.black,),
                                    Text('MapView',
                                      style: TextStyle(
                                          color: Colors.black
                                      ),),
                                  ],
                                ),
                                style: ButtonStyle(
                                  backgroundColor: MaterialStateProperty.all(mapViewButtonColor),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),

                    Spacer(),
                    OutlinedButton(
                        onPressed: () {
                          // Push the MainFilterUI route to the navigator stack
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => FilterUI()),
                          );
                        },
                        child: Text("Filter Innovation-Hubs",
                        style: TextStyle(
                          color: Colors.black
                        ),))
                  ],
                ),
              ),
              // Display either ListView or MapView based on selection
              Expanded(
                child: isListViewSelected
                    ? InnoHubListWidget()
                    : InnoMap(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/*import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:webapp_innovation_leadership/dashboard.dart';
import 'package:webapp_innovation_leadership/datamanager/QuestionProvider.dart';
import 'package:webapp_innovation_leadership/side_menu_controller.dart';
import 'package:webapp_innovation_leadership/widget/responsive.dart';
import 'package:webapp_innovation_leadership/widget/side_menu.dart';

import 'datamanager/InnovationHub.dart';
import 'datamanager/InnovationHubProvider.dart';


class Home extends StatefulWidget {
  const Home({super.key});
  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final InnovationHubProvider provider = InnovationHubProvider();
  final QuestionProvider provider2 = QuestionProvider();
  @override
  void initState() {
    provider.loadInnovationHubsFromFirestore();
  }


  @override
  Widget build(BuildContext context) {

    final sideMenuController = Provider.of<SideMenuController>(context);

    return Scaffold(
      key: sideMenuController.scaffoldKey,
      drawer: const SideMenu(),
      body: Row(
        children: [
          Expanded(
              flex: 5,
              child: Dashboard()
          ),
        ],
      ),
    );
  }
}*/
