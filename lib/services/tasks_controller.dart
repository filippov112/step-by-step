

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
  Future addTask(TaskModel newTask) async {
    await provider.insert(newTask);
    await load();
  }
}