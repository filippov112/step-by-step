import 'package:chaos_control/models/enums/wall_status.dart';
import 'package:flutter/material.dart';
import 'package:chaos_control/models/wall.dart';
import 'package:chaos_control/models/enums/wall_priority.dart';
import 'package:chaos_control/models/enums/wall_difficulty.dart';

enum SortTaskField { title, priority, difficulty }

enum TaskDateFilterType { date, all }

class TaskListModel extends ChangeNotifier {
  final TaskRepository _taskRepo = TaskRepository();

  List<Wall> _allTasks = [];
  List<Wall> _filteredTasks = [];

  // Состояние фильтрации
  String _searchQuery = '';
  final Set<WallPriority> _filterPriority = <WallPriority>{};
  final Set<WallDiff> _filterDifficulty = <WallDiff>{};
  bool _filterDone = false;
  bool _filterUndone = true;
  TaskDateFilterType dateFilter = TaskDateFilterType.date;
  DateTime? selectedDate;

  // Состояние сортировки
  SortTaskField _sortField = SortTaskField.title;
  bool _sortAscending = true;

  // Режим выделения
  bool _isSelectionMode = false;
  Set<String> _selectedIds = {};

  // Геттеры
  List<Wall> get tasks => _filteredTasks;
  bool get isSelectionMode => _isSelectionMode;
  Set<String> get selectedIds => _selectedIds;
  String get searchQuery => _searchQuery;

  SortTaskField get sortField => _sortField;
  bool get sortAscending => _sortAscending;

  Set<WallPriority> get filterPriority => _filterPriority;
  Set<WallDiff> get filterDifficulty => _filterDifficulty;
  bool get filterDone => _filterDone;
  bool get filterUndone => _filterUndone;

  bool get hasActiveFilters {
    return _searchQuery.isNotEmpty ||
        _filterPriority.isNotEmpty ||
        _filterDifficulty.isNotEmpty ||
        _filterDone ||
        !_filterUndone ||
        dateFilter != TaskDateFilterType.date;
  }

  // Загрузка данных
  Future<void> loadTasks() async {
    _allTasks = await _taskRepo.getAll();
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

  Future setPriorityFilter(WallPriority priority) async {
    if (_filterPriority.contains(priority)) {
      _filterPriority.remove(priority);
    } else {
      _filterPriority.add(priority);
    }
    await _applyFiltersAndSort();
    notifyListeners();
  }

  Future setDifficultyFilter(WallDiff difficulty) async {
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
    var result = List<Wall>.from(_allTasks);
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
      result = result.where((t) => t.status == WallStatus.destroyed).toList();
    }
    if (_filterUndone) {
      result = result.where((t) => t.status != WallStatus.destroyed).toList();
    }
   
    // Сортировка
    switch (_sortField) {
      case SortTaskField.title:
        result.sort((a, b) => a.title.compareTo(b.title));
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

  Future updateTask(Wall task) async {
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
      status: task.status,
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
