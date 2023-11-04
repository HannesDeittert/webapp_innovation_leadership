import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:webapp_innovation_leadership/side_menu_controller.dart';
import 'datamanager/DetailedHubInfoProvider.dart';
import 'datamanager/InnovationHubProvider.dart';
import 'home.dart';


void main() {
  runApp(MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => SideMenuController()),
        ChangeNotifierProvider(create: (_) => InnovationHubProvider()),
        ChangeNotifierProvider(create: (_) => DetailedHubInfoProvider()),
      ],
      child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(

        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: Home(),
    );
  }
}

