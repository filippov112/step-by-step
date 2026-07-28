import 'package:flutter/material.dart';
import 'package:life_game/models/task.dart';
import 'package:life_game/screens/tasks/widgets/task_tile.dart';

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
    
    List<TaskModel> taskList = [
      TaskModel(
          title: "Pawan Kumar",
          description: "Hey Flutter, You are so amazing !",
          dateTime: DateTime(2026, 2, 13,14,33,15),
          exp: 100
      ),
      TaskModel(
          title: "Harvey Spectre",
          description: "Hey I have hacked whatsapp!",
          dateTime: DateTime(2026, 8, 13,13,33,15),
          exp: 200
      ),
      TaskModel(
          title: "Mike Ross",
          description: "Wassup !",
          dateTime: DateTime(2026, 5, 13,11,33,15),
          exp: 300
      ),
      TaskModel(
          title: "Rachel",
          description: "I'm good!",
          dateTime: DateTime(2026, 3, 13,1,33,15),
          exp: 400
      ),
      TaskModel(
          title: "Barry Allen",
          description: "I'm the fastest man alive!",
          dateTime: DateTime(2026, 1, 3,14,33,15),
          exp: 500
      ),
      TaskModel(
          title: "Joe West",
          description: "Hey Flutter, You are so cool !",
          dateTime: DateTime(2026, 4, 5,14,33,15),
          exp: 1000
      ),
    ];

    // Верстка
    return ListView.builder(
      itemCount: taskList.length,
      itemBuilder: (context, i) => TaskTile(task: taskList[i],)
    );
  }
}