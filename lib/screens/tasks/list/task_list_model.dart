// lib/screens/tasks/task_list_model.dart
import 'package:flutter/material.dart';
import 'package:life_game/models/tag.dart';
import 'package:life_game/models/task.dart';
import 'package:life_game/models/task_hierarchy.dart';
import 'package:life_game/models/enums/task_priority.dart';
import 'package:life_game/models/enums/task_difficulty.dart';

enum SortField { title, datetime, priority, difficulty }

class TaskListModel extends ChangeNotifier {
  final TaskRepository _taskRepo = TaskRepository();
  final TagTaskRepository _tagTaskRepo = TagTaskRepository();
  final TagRepository _tagRepo = TagRepository();
  final TaskHierarchyRepository _hierarchyRepo = TaskHierarchyRepository();
  
  List<Task> _allTasks = [];
  List<Task> _filteredTasks = [];
  List<Tag> _allTags = [];
  
  // Состояние фильтрации
  String _searchQuery = '';
  TaskPriority? _filterPriority;
  TaskDifficulty? _filterDifficulty;
  bool _filterDone = false;
  bool _filterUndone = false;
  List<Tag> _selectedTags = [];
  
  // Состояние сортировки
  
  SortField _sortField = SortField.datetime;
  bool _sortAscending = true;
  
  // Режим выделения
  bool _isSelectionMode = false;
  Set<String> _selectedIds = {};
  
  // Геттеры
  List<Task> get tasks => _filteredTasks;
  List<Tag> get allTags => _allTags;
  bool get isSelectionMode => _isSelectionMode;
  Set<String> get selectedIds => _selectedIds;
  String get searchQuery => _searchQuery;
  
  SortField get sortField => _sortField;
  bool get sortAscending => _sortAscending;
  
  TaskPriority? get filterPriority => _filterPriority;
  TaskDifficulty? get filterDifficulty => _filterDifficulty;
  bool get filterDone => _filterDone;
  bool get filterUndone => _filterUndone;
  List<Tag> get selectedTags => _selectedTags;
  
  bool get hasActiveFilters {
    return _searchQuery.isNotEmpty ||
           _filterPriority != null ||
           _filterDifficulty != null ||
           _filterDone ||
           _filterUndone ||
           _selectedTags.isNotEmpty;
  }
  
  // Загрузка данных
  Future<void> loadTasks() async {
    _allTasks = await _taskRepo.getAll();
    _allTags = await _tagRepo.getAll();
    _applyFiltersAndSort();
    notifyListeners();
  }
  
  // Поиск
  void setSearchQuery(String query) {
    _searchQuery = query;
    _applyFiltersAndSort();
    notifyListeners();
  }
  
  void clearSearch() {
    _searchQuery = '';
    _applyFiltersAndSort();
    notifyListeners();
  }
  
  // Фильтры
  void setPriorityFilter(TaskPriority? priority) {
    _filterPriority = _filterPriority == priority ? null : priority;
    _applyFiltersAndSort();
    notifyListeners();
  }
  
  void setDifficultyFilter(TaskDifficulty? difficulty) {
    _filterDifficulty = _filterDifficulty == difficulty ? null : difficulty;
    _applyFiltersAndSort();
    notifyListeners();
  }
  
  void toggleDoneFilter() {
    _filterDone = !_filterDone;
    if (_filterDone) _filterUndone = false;
    _applyFiltersAndSort();
    notifyListeners();
  }
  
  void toggleUndoneFilter() {
    _filterUndone = !_filterUndone;
    if (_filterUndone) _filterDone = false;
    _applyFiltersAndSort();
    notifyListeners();
  }
  
  void setTagsFilter(List<Tag> tags) {
    _selectedTags = tags;
    _applyFiltersAndSort();
    notifyListeners();
  }
  
  void clearAllFilters() {
    _searchQuery = '';
    _filterPriority = null;
    _filterDifficulty = null;
    _filterDone = false;
    _filterUndone = false;
    _selectedTags = [];
    _applyFiltersAndSort();
    notifyListeners();
  }
  
  // Сортировка
  void setSortField(SortField field) {
    if (_sortField == field) {
      _sortAscending = !_sortAscending;
    } else {
      _sortField = field;
      _sortAscending = true;
    }
    _applyFiltersAndSort();
    notifyListeners();
  }
  
  // Основная логика фильтрации и сортировки
  void _applyFiltersAndSort() {
    var result = List<Task>.from(_allTasks);
    
    // Поиск
    if (_searchQuery.isNotEmpty) {
      final query = _searchQuery.toLowerCase();
      result = result.where((t) =>
        t.title.toLowerCase().contains(query) ||
        t.description.toLowerCase().contains(query)
      ).toList();
    }
    
    // Фильтры по приоритету и сложности
    if (_filterPriority != null) {
      result = result.where((t) => t.priority == _filterPriority).toList();
    }
    if (_filterDifficulty != null) {
      result = result.where((t) => t.difficulty == _filterDifficulty).toList();
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
      // Здесь должна быть логика фильтрации по тегам через TagTaskRepository
      // Для упрощения пока пропускаем
    }
    
    // Сортировка
    switch (_sortField) {
      case SortField.title:
        result.sort((a, b) => a.title.compareTo(b.title));
        break;
      case SortField.datetime:
        result.sort((a, b) {
          final aDate = a.datetime ?? DateTime.now();
          final bDate = b.datetime ?? DateTime.now();
          return aDate.compareTo(bDate);
        });
        break;
      case SortField.priority:
        result.sort((a, b) => a.priority.index.compareTo(b.priority.index));
        break;
      case SortField.difficulty:
        result.sort((a, b) => a.difficulty.index.compareTo(b.difficulty.index));
        break;
    }
    
    if (!_sortAscending) {
      result = result.reversed.toList();
    }
    
    _filteredTasks = result;
  }
  
  // CRUD операции
  Future<void> addTask(Task task) async {
    await _taskRepo.insert(task);
    _allTasks.add(task);
    _applyFiltersAndSort();
    notifyListeners();
  }
  
  Future<void> updateTask(Task task) async {
    await _taskRepo.update(task);
    final index = _allTasks.indexWhere((t) => t.id == task.id);
    if (index != -1) {
      _allTasks[index] = task;
    }
    _applyFiltersAndSort();
    notifyListeners();
  }
  
  Future<void> deleteTask(String id) async {
    await _taskRepo.delete(id);
    _allTasks.removeWhere((t) => t.id == id);
    _selectedIds.remove(id);
    _applyFiltersAndSort();
    notifyListeners();
  }
  
  Future<void> deleteSelectedTasks() async {
    for (final id in _selectedIds) {
      await _taskRepo.delete(id);
      _allTasks.removeWhere((t) => t.id == id);
    }
    _selectedIds.clear();
    _isSelectionMode = false;
    _applyFiltersAndSort();
    notifyListeners();
  }
  
  Future<void> toggleTaskDone(String id) async {
    final task = _allTasks.firstWhere((t) => t.id == id);
    final updated = task.copyWith(done: !task.done);
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