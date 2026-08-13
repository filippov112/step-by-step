import 'package:flutter/material.dart';
import 'package:life_game/models/task.dart';

class TaskFormModel extends ChangeNotifier {
  late TaskRepository provider = TaskRepository();

  TaskFormModel();

  final formKey = GlobalKey<FormState>();
  DateTime? datetime;
  String title = '';
  String description = '';



  void selectDateTime(DateTime dt) {
    datetime = dt;
    notifyListeners();
  }
  void selectTitle(String t) {
    title = t;
    notifyListeners();
  }
  void selectDesc(String d) {
    description = d;
    notifyListeners();
  }

  Future<String?> saveTask() async {
    final form = formKey.currentState;
    if (form != null && form.validate()) {
      form.save();
      try {
        await provider.insert(Task.create(title: title, description: description, datetime: datetime));
      } catch (e) {
        return e.toString();
      }
    }
    return null;
  }
}