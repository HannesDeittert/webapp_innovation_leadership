import 'package:flutter/material.dart';


class Responsive extends StatelessWidget{
  final Widget mobile;
  final Widget tablet;
  final Widget desktop;


  const Responsive(
      {super.key,
      required this.desktop,
      required this.mobile,
      required this.tablet});

  static bool isMobile(BuildContext context) => MediaQuery.of(context).size.width < 850;

  static bool isTablet(BuildContext context) => MediaQuery.of(context).size.width >= 850 && MediaQuery.of(context).size.width < 1100;

  static bool isDesktop(BuildContext context) => MediaQuery.of(context).size.width >= 1100;

  @override
  Widget build(BuildContext context){
    if (isDesktop(context)){
      return desktop;
    } else if (isMobile(context)){
      return mobile;
    } else {
      return tablet;
    }
  }

}