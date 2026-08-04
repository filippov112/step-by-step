import 'package:flutter/foundation.dart';
import 'package:life_game/models/task.dart';

class TaskListVM extends ChangeNotifier {
  final ValueNotifier<List<TaskModel>> tasks = ValueNotifier([]);
  late TaskProvider provider = TaskProvider();

  TaskListVM();

  Future load() async {
    try {
      List<TaskModel> tskList = await provider.getAll();
      tasks.value = tskList;
      // notifyListeners();
    } catch (e) {
      print(e);
    }
  }
}