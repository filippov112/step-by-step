import 'package:flutter/foundation.dart';
import 'package:life_game/models/task.dart';

class TaskListModel extends ChangeNotifier {
  List<Task> tasks = [];
  late TaskRepository provider = TaskRepository();

  Future load() async {
    try {
      List<Task> tskList = await provider.getAll();
      tasks = tskList;
      notifyListeners();
    } catch (e) {
      print(e);
    }
  }

  Future completeTask(Task task, bool? val) async {
    task.done = val ?? false;
    await update(task);
  }

  Future update(Task task) async {
    try {
      await provider.update(task);
      await load();
    } catch (e) {
      print(e);
    }
  }
}