import 'package:flutter/material.dart';
import 'package:life_game/models/tag.dart';
import 'package:life_game/models/tag_task.dart';
import 'package:life_game/models/task.dart';
import 'package:life_game/models/task_hierarchy.dart';

class TaskDetailModel extends ChangeNotifier {
  final TaskRepository _taskRepo = TaskRepository();
  final TaskHierarchyRepository _hierarchyRepo = TaskHierarchyRepository();
  final tagTaskRepo = TagTaskRepository();
  
  final tagRepo = TagRepository();

  late Task task;
  List<Tag> allTags = [];
  
  Map<String,int> childTasksCount = {};
  Map<String,int> childDoneTasksCount = {};
  bool sortAscending = true;
  bool isLoading = true;
  
  List<Task> _subtasks = [];
  List<Task> get subtasks => _subtasks;

  void setLoading(bool value) {
    isLoading = value;
  }

  Future<bool> checkExist() async {
    return await _taskRepo.get(task.id) != null;
  }

  Future<void> _loadTaskTags() async {
    var tagTasks = (await tagTaskRepo.getAll()).where((tt) => tt.taskId == task.id).toList();
    final tags = <Tag>[];

    for (final tt in tagTasks) {
      final tag = await tagRepo.get(tt.tagId);
      if (tag != null) {
        tags.add(tag);
      }
    }
    allTags = tags;
    notifyListeners();
  }

  Future setTask(Task tsk) async {
    task = tsk;
    await _loadTaskTags();
    await loadSubtasks();
  }
  // Загрузка данных
  Future<void> loadSubtasks() async {
    _subtasks = await _hierarchyRepo.getByParent(task.id);
    await _applyFiltersAndSort();
    setLoading(false);
    notifyListeners();
  }

  Future setSorting() async {
    sortAscending = !sortAscending;
    await _applyFiltersAndSort();
    notifyListeners();
  }

  void setDone() async {
    task.datetime = task.datetime ?? (task.done == false ? DateTime.now() : null);
    task.done = !task.done;
    await updateTask(task);
    notifyListeners();
  }

  Future<void> toggleTaskDone(String id) async {
    final task = _subtasks.firstWhere((t) => t.id == id);
    final updated = task.copyWith(
      done: !task.done, 
      datetime: task.datetime ?? (task.done == false ? DateTime.now() : null) 
    );
    await updateTask(updated);
  }

  Future deleteTask(String id) async {
    await _taskRepo.delete(id);
    _subtasks.removeWhere((t) => t.id == id);
    _applyFiltersAndSort();
    notifyListeners();
  }

  Future deleteThisTask() async {
    await deleteTask(task.id);
  }

  Future updateTask(Task task) async {
    await _taskRepo.update(task);
    final index = _subtasks.indexWhere((t) => t.id == task.id);
    if (index != -1) {
      _subtasks[index] = task;
    }
    await _applyFiltersAndSort();
    notifyListeners();
  }

  // Основная логика фильтрации и сортировки
  Future _applyFiltersAndSort() async {
    var result = List<Task>.from(_subtasks);

    // Получение счетчиков подзадач
    childTasksCount.clear();
    childDoneTasksCount.clear();
    for (var task in result) {
      var children = await _hierarchyRepo.getByParent(task.id);
      childTasksCount[task.id] = children.length;
      childDoneTasksCount[task.id] = children.where((e) => e.done).length;
    }
    // Сортировка
    result.sort((a, b) {
      final aDate = a.datetime ?? DateTime.now();
      final bDate = b.datetime ?? DateTime.now();
      return aDate.compareTo(bDate);
    });
    if (!sortAscending) {
      result = result.reversed.toList();
    }
  }
}