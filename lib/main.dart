import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart';
import 'package:webapp_innovation_leadership/Homepage.dart';
import 'package:webapp_innovation_leadership/datamanager/QuestionProvider.dart';
import 'package:webapp_innovation_leadership/side_menu_controller.dart';
import 'datamanager/DetailedHubInfoProvider.dart';
import 'datamanager/EventProvieder.dart';
import 'datamanager/InnovationHubProvider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:webapp_innovation_leadership/firebase_options.dart';

import 'datamanager/UserProvider.dart';
import 'datamanager/WorkProvider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  final innovationHubProvider = InnovationHubProvider();
  await innovationHubProvider.loadInnovationHubsFromFirestore();
 // debugRepaintRainbowEnabled = true;
  runApp(MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => SideMenuController()),
        ChangeNotifierProvider(create: (_) => innovationHubProvider),
        ChangeNotifierProvider(create: (_) => DetailedHubInfoProvider()),
        ChangeNotifierProvider(create: (_) => QuestionProvider()),
        ChangeNotifierProvider(create: (_) => UserProvider()),
        ChangeNotifierProvider(create: (_) => EventProvider()),
        ChangeNotifierProvider(create: (_) => WorkProvider()),


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
        scaffoldBackgroundColor: Colors.black12
      ),
      home: MyHomePage(),
    );
  }
}

