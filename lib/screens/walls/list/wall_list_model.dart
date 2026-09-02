import 'package:chaos_control/models/enums/wall_status.dart';
import 'package:flutter/material.dart';
import 'package:chaos_control/models/wall.dart';
import 'package:chaos_control/models/enums/wall_difficulty.dart';

enum SortTaskField { title, difficulty }
enum WallDateFilterType { date, all }

class WallListModel extends ChangeNotifier {
  final WallRepository _wallRepo = WallRepository();

  List<Wall> _allWalls = [];
  List<Wall> filteredWalls = [];

  // Состояние фильтрации
  String searchQuery = '';
  final Set<WallDiff> filterDifficulty = <WallDiff>{};
  bool filterDone = false;
  bool filterUndone = true;
  WallDateFilterType dateFilter = WallDateFilterType.date;
  DateTime? selectedDate;

  // Состояние сортировки
  SortTaskField sortField = SortTaskField.title;
  bool sortAscending = true;

  // Режим выделения
  bool isSelectionMode = false;
  Set<String> selectedIds = {};
  
  bool get hasActiveFilters {
    return searchQuery.isNotEmpty ||
        filterDifficulty.isNotEmpty ||
        filterDone ||
        !filterUndone ||
        dateFilter != WallDateFilterType.date;
  }

  // Загрузка данных
  Future<void> loadTasks() async {
    _allWalls = await _wallRepo.getAll();
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
    searchQuery = query;
    await _applyFiltersAndSort();
    notifyListeners();
  }

  Future clearSearch() async {
    searchQuery = '';
    await _applyFiltersAndSort();
    notifyListeners();
  }

  // Фильтры
  Future selectDate(DateTime date) async {
    selectedDate = date;
    await _applyFiltersAndSort();
    notifyListeners();
  }

  Future setDifficultyFilter(WallDiff difficulty) async {
    if (filterDifficulty.contains(difficulty)) {
      filterDifficulty.remove(difficulty);
    } else {
      filterDifficulty.add(difficulty);
    }
    await _applyFiltersAndSort();
    notifyListeners();
  }

  Future toggleDoneFilter() async {
    filterDone = !filterDone;
    if (filterDone) filterUndone = false;
    await _applyFiltersAndSort();
    notifyListeners();
  }

  Future setDateFilter(WallDateFilterType value) async {
    if (value == dateFilter) return;
    dateFilter = value;
    await _applyFiltersAndSort();
    notifyListeners();
  }

  Future toggleUndoneFilter() async {
    filterUndone = !filterUndone;
    if (filterUndone) filterDone = false;
    await _applyFiltersAndSort();
    notifyListeners();
  }


  void clearAllFilters() {
    searchQuery = '';
    filterDifficulty.clear();
    filterDone = false;
    filterUndone = true;
    dateFilter = WallDateFilterType.date;
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
    if (sortField == field) {
      sortAscending = !sortAscending;
    } else {
      sortField = field;
      sortAscending = true;
    }
    await _applyFiltersAndSort();
    notifyListeners();
  }

  // Основная логика фильтрации и сортировки
  Future _applyFiltersAndSort() async {
    var result = List<Wall>.from(_allWalls);
    // Поиск
    if (searchQuery.isNotEmpty) {
      final query = searchQuery.toLowerCase();
      result = result
          .where(
            (t) =>
                t.title.toLowerCase().contains(query) ||
                t.target.toLowerCase().contains(query),
          )
          .toList();
    }
    
    // Фильтры по приоритету и сложности
    if (filterDifficulty.isNotEmpty) {
      result = result
          .where((t) => filterDifficulty.contains(t.difficulty))
          .toList();
    }
    // Фильтр по статусу
    if (filterDone) {
      result = result.where((t) => t.status == WallStatus.destroyed).toList();
    }
    if (filterUndone) {
      result = result.where((t) => t.status != WallStatus.destroyed).toList();
    }
   
    // Сортировка
    switch (sortField) {
      case SortTaskField.title:
        result.sort((a, b) => a.title.compareTo(b.title));
        break;
      case SortTaskField.difficulty:
        result.sort((a, b) => a.difficulty.index.compareTo(b.difficulty.index));
        break;
    }
    if (!sortAscending) {
      result = result.reversed.toList();
    }
    filteredWalls = result;
  }

  Future updateTask(Wall task) async {
    await _wallRepo.update(task);
    final index = _allWalls.indexWhere((t) => t.id == task.id);
    if (index != -1) {
      _allWalls[index] = task;
    }
    await _applyFiltersAndSort();
    notifyListeners();
  }

  Future deleteTask(String id) async {
    await _wallRepo.delete(id);
    _allWalls.removeWhere((t) => t.id == id);
    selectedIds.remove(id);
    _applyFiltersAndSort();
    notifyListeners();
  }

  Future deleteSelectedTasks() async {
    for (final id in selectedIds) {
      await _wallRepo.delete(id);
      _allWalls.removeWhere((t) => t.id == id);
    }
    selectedIds.clear();
    isSelectionMode = false;
    await _applyFiltersAndSort();
    notifyListeners();
  }

  Future<void> toggleTaskDone(String id) async {
    final task = _allWalls.firstWhere((t) => t.id == id);
    final updated = task.copyWith(
      status: task.status,
    );
    await updateTask(updated);
  }

  // Режим выделения
  void toggleSelectionMode() {
    isSelectionMode = !isSelectionMode;
    if (!isSelectionMode) {
      selectedIds.clear();
    }
    notifyListeners();
  }

  void toggleSelectAll() {
    if (selectedIds.length == filteredWalls.length) {
      selectedIds.clear();
    } else {
      selectedIds = filteredWalls.map((t) => t.id).toSet();
    }
    notifyListeners();
  }

  void toggleSelectTask(String id) {
    if (selectedIds.contains(id)) {
      selectedIds.remove(id);
    } else {
      selectedIds.add(id);
    }
    notifyListeners();
  }

  void clearSelection() {
    selectedIds.clear();
    isSelectionMode = false;
    notifyListeners();
  }
}
