import 'package:flutter/material.dart';
import 'package:life_game/models/task.dart';

class CreateTaskVM extends ChangeNotifier {
  late TaskRepository provider = TaskRepository();

  CreateTaskVM();

  Future addTask(Task newTask) async {
    await provider.insert(newTask);
  }
}