import 'package:flutter/material.dart';
import 'package:life_game/models/task.dart';

class CreateTaskVM extends ChangeNotifier {
  late TaskProvider provider = TaskProvider();

  CreateTaskVM();

  Future addTask(TaskModel newTask) async {
    await provider.insert(newTask);
  }
}