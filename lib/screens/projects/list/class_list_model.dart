import 'package:flutter/material.dart';
import 'package:chaos_control/models/class.dart';


enum SortClassField { title }

class ClassListModel extends ChangeNotifier {
  final ClassRepository _classRepo = ClassRepository();

  List<Class> _records = [];
  List<Class> _filteredRecords = [];
  
  // Состояние фильтрации
  String _searchQuery = '';

  // Состояние сортировки
  SortClassField _sortField = SortClassField.title;
  bool _sortAscending = true;
  
  // Режим выделения
  bool _isSelectionMode = false;
  Set<String> _selectedIds = {};
  
  // Геттеры
  List<Class> get records => _filteredRecords;
  bool get isSelectionMode => _isSelectionMode;
  Set<String> get selectedIds => _selectedIds;
  String get searchQuery => _searchQuery;
  
  SortClassField get sortField => _sortField;
  bool get sortAscending => _sortAscending;
  
  
  bool get hasActiveFilters {
    return _searchQuery.isNotEmpty;
  }
  
  // Загрузка данных
  Future loadData() async {
    _records = await _classRepo.getAll();
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
  void clearAllFilters() {
    _searchQuery = '';
    _applyFiltersAndSort();
    notifyListeners();
  }
  
  // Сортировка
  Future setSortField(SortClassField field) async {
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
    var result = List<Class>.from(_records);
    // Поиск
    if (_searchQuery.isNotEmpty) {
      final query = _searchQuery.toLowerCase();
      result = result.where((t) =>
        t.title.toLowerCase().contains(query) ||
        t.description.toLowerCase().contains(query)
      ).toList();
    }
    // Фильтры
    // Сортировка
    switch (_sortField) {
      case SortClassField.title:
        result.sort((a, b) => a.title.compareTo(b.title));
        break;
    }
    if (!_sortAscending) {
      result = result.reversed.toList();
    }
    _filteredRecords = result;
  }
  
  Future update(Class cls) async {
    await _classRepo.update(cls);
    final index = _records.indexWhere((t) => t.id == cls.id);
    if (index != -1) {
      _records[index] = cls;
    }
    await _applyFiltersAndSort();
    notifyListeners();
  }

  Future delete(String id) async {
    await _classRepo.delete(id);
    _records.removeWhere((t) => t.id == id);
    _selectedIds.remove(id);
    _applyFiltersAndSort();
    notifyListeners();
  }
  
  Future deleteAllSelected() async {
    for (final id in _selectedIds) {
      await _classRepo.delete(id);
      _records.removeWhere((t) => t.id == id);
    }
    _selectedIds.clear();
    _isSelectionMode = false;
    await _applyFiltersAndSort();
    notifyListeners();
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
    if (_selectedIds.length == _filteredRecords.length) {
      _selectedIds.clear();
    } else {
      _selectedIds = _filteredRecords.map((t) => t.id).toSet();
    }
    notifyListeners();
  }
  
  void toggleSelect(String id) {
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