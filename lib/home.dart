import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:webapp_innovation_leadership/dashboard.dart';
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
}
