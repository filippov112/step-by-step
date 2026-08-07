import 'package:flutter/material.dart';
import 'package:life_game/models/task.dart';

class TaskCreateModel extends ChangeNotifier {
  late TaskRepository provider = TaskRepository();

  TaskCreateModel();

  Future addTask(Task newTask) async {
    await provider.insert(newTask);
  }
}