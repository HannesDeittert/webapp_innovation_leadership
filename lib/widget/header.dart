import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:webapp_innovation_leadership/Constants/Colors.dart';
import 'package:webapp_innovation_leadership/side_menu_controller.dart';
import 'package:webapp_innovation_leadership/widget/responsive.dart';


class Header extends StatelessWidget {
  const Header({super.key});

  @override
  Widget build(BuildContext context) {
    final sideMenuController = Provider.of<SideMenuController>(context);
    return Row(
      children: [
          IconButton(
              onPressed: sideMenuController.controllMenu,
              icon: Icon(Icons.menu, color: tDarkColor),
          ),

        if(!Responsive.isMobile(context))
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text("Dashboard"),
          )
      ],
    );
  }
}