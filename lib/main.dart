import 'package:flutter/material.dart';
import 'package:life_game/data/db.dart';
import 'package:life_game/screens/home.dart';
import 'package:life_game/screens/profile/create/create_profile_screen.dart';
import 'package:life_game/services/state_service.dart';

Future main() async {
  await DB.initDb();
  await StateService.initState();
  
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Chaos Control',
      theme: ThemeData(
        colorScheme: .fromSeed(seedColor: const Color.fromARGB(255, 9, 151, 80)),
      ),
      home: StateService.profile == null ? CreateProfileScreen() : Home(),
    );
  }
}


