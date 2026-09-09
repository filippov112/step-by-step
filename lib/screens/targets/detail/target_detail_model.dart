import 'package:chaos_control/models/barrier.dart';
import 'package:chaos_control/models/project.dart';
import 'package:flutter/material.dart';
import 'package:chaos_control/models/target.dart';

class TargetDetailModel extends ChangeNotifier {
  final _targetRepo = TargetRepository();
  final _projectRepo = ProjectRepository();
  final _taskRepo = TaskRepository();

  Target target = Target.create(title: '', desc: '');
  List<Barrier> tasks = [];
  int currentTabIndex = 0;
  bool visibilityTaskForm = false;

  Project? project;

  // ------------ Main -----------------

  Future<bool> checkExist() async {
    final updatedTarget = await _targetRepo.get(target.id);
    if (updatedTarget == null) return false;
    target = updatedTarget;
    await _loadProject();
    notifyListeners();
    return true;
  }

  Future setTarget(Target trg) async {
    target = trg;
    await _loadProject();
    await _loadTasks();
    notifyListeners();
  }

  Future _loadProject() async {
    project = target.projectId == null ? null : await _projectRepo.get(target.projectId!);
  }
  Future _loadTasks() async {
    tasks = (await _taskRepo.getByTarget(target.id))..sort((a,b) => b.date.compareTo(a.date));
  }

  void changeTabIndex(int index) {
    currentTabIndex = index;
    notifyListeners();
  }

  // ------------ Tasks --------------

  Barrier? editionTask;

  void openForm(Barrier? task) {
    visibilityTaskForm = true;
    editionTask = task;
    notifyListeners();
  }

  Future saveTask() async {
    await _loadTasks();
    closeTaskForm();
  }

  void closeTaskForm() {
    visibilityTaskForm = false;
    editionTask = null;
    notifyListeners();
  }

  Future deleteAllSelectedTasks() async {
    for (final id in selectedIds) {
      await _taskRepo.delete(id);
    }
    selectedIds = {};
    isSelectionMode = false;
    await _loadTasks();
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
      visibilityTaskForm = false;
    }
    notifyListeners();
  }
  void toggleSelectAll() {
    if (selectedIds.length == tasks.length) {
      selectedIds = {};
    } else {
      selectedIds = tasks.map((t) => t.id).toSet();
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

  // ------------ Target -----------------

  Future setFavorite(bool value) async {
    target.favorite = value;
    await _targetRepo.update(target);
    notifyListeners();
    notifyListeners();
  }

  Future deleteTarget() async {
    await _targetRepo.delete(target.id);
    notifyListeners();
  }
}