

import 'package:flutter/foundation.dart';
import 'package:life_game/models/task.dart';

class TasksController extends ChangeNotifier {
  final ValueNotifier<List<TaskModel>> tasks = ValueNotifier([]);
  late TaskProvider provider = TaskProvider();

  TasksController();

  Future load() async {
    try {
      List<TaskModel> tskList = await provider.getAllTasks();
      tasks.value = tskList;
      // notifyListeners();
    } catch (e) {
      print(e);
    }
    
  }
  Future addTask() async {
    TaskModel newTask = TaskModel(title: "Title", dateTime: DateTime.now(), exp: 100);
    await provider.insert(newTask);
    await load();
  }
}