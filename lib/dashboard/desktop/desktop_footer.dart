import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class DesktopFooter extends StatefulWidget {

  @override
  _DesktopFooterState createState() => _DesktopFooterState();
}

class _DesktopFooterState extends State<DesktopFooter> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Positioned(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height/20,
          bottom: 0,
          child: Expanded(
            child: Container(
              color: Colors.blue,
            ),
          ),
        ),
    );
  }
}