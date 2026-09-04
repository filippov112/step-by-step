import 'package:chaos_control/models/attempt.dart';
import 'package:chaos_control/models/enums/wall_status.dart';
import 'package:chaos_control/models/project.dart';
import 'package:chaos_control/services/datetool.dart';
import 'package:flutter/material.dart';
import 'package:chaos_control/models/wall.dart';

class WallDetailModel extends ChangeNotifier {
  final _taskRepo = WallRepository();
  final _projectRepo = ProjectRepository();
  final _attemptRepo = AttemptRepository();

  Wall wall = Wall.create(title: '', target: '');
  List<Attempt> attempts = [];
  int currentTabIndex = 0;
  bool visibilityAttemptForm = false;

  Project? project;

  // ------------ Main -----------------

  Future<bool> checkExist() async {
    final updatedWall = await _taskRepo.get(wall.id);
    if (updatedWall == null) return false;
    wall = updatedWall;
    notifyListeners();
    return true;
  }

  Future setWall(Wall wll) async {
    wall = wll;
    project = wll.projectId == null ? null : await _projectRepo.get(wll.projectId!);
    await _loadAttempts();
    notifyListeners();
  }

  Future _loadAttempts() async {
    attempts = await _attemptRepo.getByWall(wall.id);
  }

  void changeTabIndex(int index) {
    currentTabIndex = index;
    notifyListeners();
  }

  // ------------ Attempts --------------

  void openCreateForm() {
    visibilityAttemptForm = true;

    notifyListeners();
  }

  void closeAttemptForm() {
    visibilityAttemptForm = false;
    notifyListeners();
  }


  // ------------ Wall -----------------

  Future changeStatus() async {
    wall.status = WallStatus.values[(wall.status.index + 1) % 3];
    wall.destroyed = wall.status == WallStatus.destroyed ? DateTool.today() : null;
    await _taskRepo.update(wall);
    notifyListeners();
    notifyListeners();
  }

  Future setFavorite(bool value) async {
    wall.favorite = value;
    await _taskRepo.update(wall);
    notifyListeners();
    notifyListeners();
  }

  Future deleteWall() async {
    await _taskRepo.delete(wall.id);
    notifyListeners();
  }
}