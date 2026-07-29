import 'package:flutter/material.dart';
import 'package:life_game/data/db.dart';
import 'package:life_game/screens/tabs_menu.dart';

Future main() async {
  await DB.initDb();
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
        colorScheme: .fromSeed(seedColor: const Color.fromARGB(255, 235, 149, 21)),
      ),
      home: const TabsMenu(),
    );
  }
}


