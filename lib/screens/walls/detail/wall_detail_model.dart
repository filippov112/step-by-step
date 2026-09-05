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
    attempts = (await _attemptRepo.getByWall(wall.id))..sort((a,b) => b.date.compareTo(a.date));
  }

  void changeTabIndex(int index) {
    currentTabIndex = index;
    notifyListeners();
  }

  // ------------ Attempts --------------

  Attempt? editionAttempt;

  void openForm(Attempt? attempt) {
    visibilityAttemptForm = true;
    editionAttempt = attempt;
    notifyListeners();
  }

  Future saveAttempt() async {
    await _loadAttempts();
    closeAttemptForm();
  }

  void closeAttemptForm() {
    visibilityAttemptForm = false;
    editionAttempt = null;
    notifyListeners();
  }

  Future deleteAllSelectedAttempts() async {
    for (final id in selectedIds) {
      await _attemptRepo.delete(id);
    }
    selectedIds.clear();
    isSelectionMode = false;
    await _loadAttempts();
    notifyListeners();
  }

  // Режим выделения
  bool isSelectionMode = false;
  Set<String> selectedIds = {};
  void toggleSelectionMode() {
    isSelectionMode = !isSelectionMode;
    if (!isSelectionMode) {
      selectedIds = {};
    } else {
      visibilityAttemptForm = false;
    }
    notifyListeners();
  }
  void toggleSelectAll() {
    if (selectedIds.length == attempts.length) {
      selectedIds = {};
    } else {
      selectedIds = attempts.map((t) => t.id).toSet();
    }
    notifyListeners();
  }
  void toggleSelect(String id) {
    if (!isSelectionMode) toggleSelectionMode();

    final selectedIdsCopy = selectedIds.toSet();
    if (selectedIdsCopy.contains(id)) {
      selectedIdsCopy.remove(id);
    } else {
      selectedIdsCopy.add(id);
    }
    selectedIds = selectedIdsCopy;
    notifyListeners();
  }
  void clearSelection() {
    selectedIds = {};
    isSelectionMode = false;
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