import 'package:flutter/material.dart';

class StatsScreen extends StatefulWidget {
  const StatsScreen({super.key});

  // Тут входящие параметры виджета - final string title; Объявление полей всегда с final.

  @override
  State<StatsScreen> createState() => _StatsScreenState();
}

class _StatsScreenState extends State<StatsScreen> {
  // ViewModel - команды, свойства

  @override
  Widget build(BuildContext context) { // Виджет родитель
    // Верстка
    return Scaffold(
      body:Text("Stats")
      
    );
  }
}