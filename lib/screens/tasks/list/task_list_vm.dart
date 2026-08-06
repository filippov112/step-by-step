import 'package:flutter/foundation.dart';
import 'package:life_game/models/task.dart';

class TaskListVM extends ChangeNotifier {
  final ValueNotifier<List<TaskModel>> tasks = ValueNotifier([]);
  late TaskRepository provider = TaskRepository();

  TaskListVM();

  Future load() async {
    try {
      List<TaskModel> tskList = await provider.getAll();
      tasks.value = tskList;
    } catch (e) {
      print(e);
    }
  }

  Future update(TaskModel task) async {
    try {
      await provider.update(task);
      await load();
    } catch (e) {
      print(e);
    }
  }
}