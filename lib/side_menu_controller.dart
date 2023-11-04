import 'package:flutter/material.dart';
import 'package:webapp_innovation_leadership/datamanager/InnovationHub.dart';

class SideMenuController extends ChangeNotifier{

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState> ();

  GlobalKey<ScaffoldState> get scaffoldKey => _scaffoldKey;



  void controllMenu(){
    if(!_scaffoldKey.currentState!.isDrawerOpen){
      _scaffoldKey.currentState!.openDrawer();
    }
  }

}