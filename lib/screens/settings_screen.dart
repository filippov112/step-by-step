import 'package:flutter/material.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  // Тут входящие параметры виджета - final string title; Объявление полей всегда с final.

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  // ViewModel - команды, свойства

  @override
  Widget build(BuildContext context) { // Виджет родитель
    // Верстка
    return Scaffold(
      body:Text("Settings")
      
    );
  }
}