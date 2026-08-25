import 'package:flutter/material.dart';
import 'package:chaos_control/models/tag.dart';
import 'package:chaos_control/models/tag_task.dart';
import 'package:chaos_control/models/task.dart';
import 'package:chaos_control/models/task_hierarchy.dart';
import 'package:chaos_control/models/enums/task_priority.dart';
import 'package:chaos_control/models/enums/task_difficulty.dart';

enum SortTaskField { title, datetime, priority, difficulty }

enum TaskDateFilterType { date, all }

class TaskListModel extends ChangeNotifier {
  final TaskRepository _taskRepo = TaskRepository();
  final TagTaskRepository _tagTaskRepo = TagTaskRepository();
  final TaskHierarchyRepository _hierarchyRepo = TaskHierarchyRepository();

  Map<String, int> childTasksCount = {};
  Map<String, int> childDoneTasksCount = {};

  List<Task> _allTasks = [];
  List<Task> _filteredTasks = [];
  List<TagTask> _allTagTasks = [];

  // Состояние фильтрации
  String _searchQuery = '';
  final Set<TaskPriority> _filterPriority = <TaskPriority>{};
  final Set<TaskDifficulty> _filterDifficulty = <TaskDifficulty>{};
  bool _filterDone = false;
  bool _filterUndone = true;
  List<Tag> _selectedTags = [];
  TaskDateFilterType dateFilter = TaskDateFilterType.date;
  DateTime? selectedDate;

  // Состояние сортировки
  SortTaskField _sortField = SortTaskField.datetime;
  bool _sortAscending = true;

  // Режим выделения
  bool _isSelectionMode = false;
  Set<String> _selectedIds = {};

  // Геттеры
  List<Task> get tasks => _filteredTasks;
  List<TagTask> get allTags => _allTagTasks;
  bool get isSelectionMode => _isSelectionMode;
  Set<String> get selectedIds => _selectedIds;
  String get searchQuery => _searchQuery;

  SortTaskField get sortField => _sortField;
  bool get sortAscending => _sortAscending;

  Set<TaskPriority> get filterPriority => _filterPriority;
  Set<TaskDifficulty> get filterDifficulty => _filterDifficulty;
  bool get filterDone => _filterDone;
  bool get filterUndone => _filterUndone;
  List<Tag> get selectedTags => _selectedTags;

  bool get hasActiveFilters {
    return _searchQuery.isNotEmpty ||
        _filterPriority.isNotEmpty ||
        _filterDifficulty.isNotEmpty ||
        _filterDone ||
        !_filterUndone ||
        _selectedTags.isNotEmpty ||
        dateFilter != TaskDateFilterType.date;
  }

  // Загрузка данных
  Future<void> loadTasks() async {
    _allTasks = await _taskRepo.getAll();
    _allTagTasks = await _tagTaskRepo.getAll();

    selectedDate = DateTime(
      DateTime.now().year,
      DateTime.now().month,
      DateTime.now().day,
    );
    await _applyFiltersAndSort();
    notifyListeners();
  }

  // Поиск
  Future setSearchQuery(String query) async {
    _searchQuery = query;
    await _applyFiltersAndSort();
    notifyListeners();
  }

  Future clearSearch() async {
    _searchQuery = '';
    await _applyFiltersAndSort();
    notifyListeners();
  }

  // Фильтры
  Future selectDate(DateTime date) async {
    selectedDate = date;
    await _applyFiltersAndSort();
    notifyListeners();
  }

  Future setPriorityFilter(TaskPriority priority) async {
    if (_filterPriority.contains(priority)) {
      _filterPriority.remove(priority);
    } else {
      _filterPriority.add(priority);
    }
    await _applyFiltersAndSort();
    notifyListeners();
  }

  Future setDifficultyFilter(TaskDifficulty difficulty) async {
    if (_filterDifficulty.contains(difficulty)) {
      _filterDifficulty.remove(difficulty);
    } else {
      _filterDifficulty.add(difficulty);
    }
    await _applyFiltersAndSort();
    notifyListeners();
  }

  Future toggleDoneFilter() async {
    _filterDone = !_filterDone;
    if (_filterDone) _filterUndone = false;
    await _applyFiltersAndSort();
    notifyListeners();
  }

  Future setDateFilter(TaskDateFilterType value) async {
    if (value == dateFilter) return;
    dateFilter = value;
    await _applyFiltersAndSort();
    notifyListeners();
  }

  Future toggleUndoneFilter() async {
    _filterUndone = !_filterUndone;
    if (_filterUndone) _filterDone = false;
    await _applyFiltersAndSort();
    notifyListeners();
  }

  Future setTagsFilter(List<Tag> tags) async {
    _selectedTags = tags;
    await _applyFiltersAndSort();
    notifyListeners();
  }

  void clearAllFilters() {
    _searchQuery = '';
    _filterPriority.clear();
    _filterDifficulty.clear();
    _filterDone = false;
    _filterUndone = true;
    dateFilter = TaskDateFilterType.date;
    selectedDate = DateTime(
      DateTime.now().year,
      DateTime.now().month,
      DateTime.now().day,
    );
    _selectedTags = [];
    _applyFiltersAndSort();
    notifyListeners();
  }

  // Сортировка
  Future setSortField(SortTaskField field) async {
    if (_sortField == field) {
      _sortAscending = !_sortAscending;
    } else {
      _sortField = field;
      _sortAscending = true;
    }
    await _applyFiltersAndSort();
    notifyListeners();
  }

  // Основная логика фильтрации и сортировки
  Future _applyFiltersAndSort() async {
    var result = List<Task>.from(_allTasks);
    // Поиск
    if (_searchQuery.isNotEmpty) {
      final query = _searchQuery.toLowerCase();
      result = result
          .where(
            (t) =>
                t.title.toLowerCase().contains(query) ||
                t.description.toLowerCase().contains(query),
          )
          .toList();
    }
    // Фильтр по дате
    if (dateFilter == TaskDateFilterType.date) {
      result = result
          .where(
            (t) =>
                t.datetime != null &&
                DateTime(
                      t.datetime!.year,
                      t.datetime!.month,
                      t.datetime!.day,
                    ) ==
                    selectedDate,
          )
          .toList();
    }
    // Фильтры по приоритету и сложности
    if (_filterPriority.isNotEmpty) {
      result = result
          .where((t) => _filterPriority.contains(t.priority))
          .toList();
    }
    if (_filterDifficulty.isNotEmpty) {
      result = result
          .where((t) => _filterDifficulty.contains(t.difficulty))
          .toList();
    }
    // Фильтр по статусу
    if (_filterDone) {
      result = result.where((t) => t.done).toList();
    }
    if (_filterUndone) {
      result = result.where((t) => !t.done).toList();
    }
    // Фильтр по тегам
    if (_selectedTags.isNotEmpty) {
      var selectedTagTasks = _allTagTasks.where(
        (tagTask) => _selectedTags.map((tag) => tag.id).contains(tagTask.tagId),
      );
      result = result
          .where(
            (task) => selectedTagTasks
                .map((tagTask) => tagTask.taskId)
                .contains(task.id),
          )
          .toList();
    }

    // Получение счетчиков подзадач
    childTasksCount.clear();
    childDoneTasksCount.clear();

    for (var task in result) {
      var children = await _hierarchyRepo.getByParent(task.id);
      childTasksCount[task.id] = children.length;
      childDoneTasksCount[task.id] = children.where((e) => e.done).length;
    }

    // Сортировка
    switch (_sortField) {
      case SortTaskField.title:
        result.sort((a, b) => a.title.compareTo(b.title));
        break;
      case SortTaskField.datetime:
        result.sort((a, b) {
          final aDate = a.datetime ?? DateTime.now();
          final bDate = b.datetime ?? DateTime.now();
          return aDate.compareTo(bDate);
        });
        break;
      case SortTaskField.priority:
        result.sort((a, b) => a.priority.index.compareTo(b.priority.index));
        break;
      case SortTaskField.difficulty:
        result.sort((a, b) => a.difficulty.index.compareTo(b.difficulty.index));
        break;
    }
    if (!_sortAscending) {
      result = result.reversed.toList();
    }
    _filteredTasks = result;
  }

  Future updateTask(Task task) async {
    await _taskRepo.update(task);
    final index = _allTasks.indexWhere((t) => t.id == task.id);
    if (index != -1) {
      _allTasks[index] = task;
    }
    await _applyFiltersAndSort();
    notifyListeners();
  }

  Future deleteTask(String id) async {
    await _taskRepo.delete(id);
    _allTasks.removeWhere((t) => t.id == id);
    _selectedIds.remove(id);
    _applyFiltersAndSort();
    notifyListeners();
  }

  Future deleteSelectedTasks() async {
    for (final id in _selectedIds) {
      await _taskRepo.delete(id);
      _allTasks.removeWhere((t) => t.id == id);
    }
    _selectedIds.clear();
    _isSelectionMode = false;
    await _applyFiltersAndSort();
    notifyListeners();
  }

  Future<void> toggleTaskDone(String id) async {
    final task = _allTasks.firstWhere((t) => t.id == id);
    final updated = task.copyWith(
      done: !task.done,
      datetime: task.datetime ?? (task.done == false ? DateTime.now() : null),
    );
    await updateTask(updated);
  }

  // Режим выделения
  void toggleSelectionMode() {
    _isSelectionMode = !_isSelectionMode;
    if (!_isSelectionMode) {
      _selectedIds.clear();
    }
    notifyListeners();
  }

  void toggleSelectAll() {
    if (_selectedIds.length == _filteredTasks.length) {
      _selectedIds.clear();
    } else {
      _selectedIds = _filteredTasks.map((t) => t.id).toSet();
    }
    notifyListeners();
  }

  void toggleSelectTask(String id) {
    if (_selectedIds.contains(id)) {
      _selectedIds.remove(id);
    } else {
      _selectedIds.add(id);
    }
    notifyListeners();
  }

  void clearSelection() {
    _selectedIds.clear();
    _isSelectionMode = false;
    notifyListeners();
  }
}
