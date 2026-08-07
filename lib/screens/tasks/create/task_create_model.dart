import 'package:flutter/material.dart';
import 'package:life_game/models/task.dart';

class TaskCreateModel extends ChangeNotifier {
  late TaskRepository provider = TaskRepository();

  TaskCreateModel();

  final formKey = GlobalKey<FormState>();
  final newTask = Task.create(title: "Новая задача");
  
  void selectDateTime(DateTime dateTime) {
    newTask.datetime = dateTime;
    notifyListeners();
  }
  void selectTitle(String title) {
    newTask.title = title;
    notifyListeners();
  }
  void selectDesc(String description) {
    newTask.description = description;
    notifyListeners();
  }

  Future<String?> saveTask() async {
    final form = formKey.currentState;
    if (form != null && form.validate()) {
      form.save();
      try {
        await provider.insert(newTask);
      } catch (e) {
        return e.toString();
      }
    }
    return null;
  }
}