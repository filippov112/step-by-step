import 'package:chaos_control/models/enums/wall_status.dart';
import 'package:flutter/material.dart';
import 'package:chaos_control/models/wall.dart';

class WallDetailModel extends ChangeNotifier {
  final TaskRepository _taskRepo = TaskRepository();

  Wall wall = Wall.create(title: '', description: '');
  
  Map<String,int> childTasksCount = {};
  Map<String,int> childDoneTasksCount = {};
  bool sortAscending = true;
  bool isLoading = true;
  

  Future<bool> checkExist() async {
    return await _taskRepo.get(wall.id) != null;
  }


  Future setTask(Wall tsk) async {
    isLoading = true;
    wall = tsk;
    notifyListeners();
  }


  void setStatus({WallStatus status = WallStatus.destroyed}) async {
    wall.status = status;
    await _taskRepo.update(wall);
    notifyListeners();
    notifyListeners();
  }


  Future deleteWall() async {
    await _taskRepo.delete(wall.id);
    notifyListeners();
  }
}