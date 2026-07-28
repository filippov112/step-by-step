import 'package:flutter/material.dart';

class TasksScreen extends StatefulWidget {
  const TasksScreen({super.key});

  // Тут входящие параметры виджета - final string title; Объявление полей всегда с final.

  @override
  State<TasksScreen> createState() => _TasksScreenState();
}

class _TasksScreenState extends State<TasksScreen> {
  // ViewModel - команды, свойства

  @override
  Widget build(BuildContext context) { // Виджет родитель
    // Верстка
    return Scaffold(
      body:Text("Tasks")
      
    );
  }
}