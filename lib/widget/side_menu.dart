import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../Constants/Colors.dart';
import '../datamanager/InnovationHub.dart';
import '../datamanager/InnovationHubProvider.dart';
import 'MyListView.dart';

class SideMenu extends StatefulWidget {
  const SideMenu({super.key});

  @override
  State<SideMenu> createState() => _SideMenu();
}

class _SideMenu extends State<SideMenu> {
  final InnovationHubProvider provider = InnovationHubProvider();
  List<InnovationHub> hubs = [];


  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: tCardBgColor,
      child: provider.loaded ? MyListView(hubs: hubs) : CircularProgressIndicator(),  // Zeigen Sie den Ladeindikator, wenn isLoading true ist, sonst zeigen Sie MyListView
    );
  }
}