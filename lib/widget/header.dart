import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:webapp_innovation_leadership/widget/responsive.dart';

import '../datamanager/InnovationHubProvider.dart';
import 'FilterWidgets/mainFilterUI.dart';


class Header extends StatelessWidget {
  const Header({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<InnovationHubProvider>(
      builder: (context, provider, child) {
        // You can access the provider's state here, e.g. provider.filteredHubs
        return Row(
          children: [
            IconButton(
              onPressed: () {
                // Push the MainFilterUI route to the navigator stack
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => FilterUI()),
                );
              },
              icon: Icon(Icons.menu, color: Colors.black),
            ),
            if (!Responsive.isMobile(context))
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text("Dashboard"),
              )
          ],
        );
      },
    );
  }
}