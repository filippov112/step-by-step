import 'package:flutter/material.dart';
import 'package:chaos_control/models/class.dart';
import 'package:chaos_control/models/tag.dart';
import 'package:chaos_control/models/tag_class.dart';


enum SortClassField { title }

class ClassListModel extends ChangeNotifier {
  final ClassRepository _classRepo = ClassRepository();
  final TagClassRepository _tagClassRepo = TagClassRepository();

  List<Class> _records = [];
  List<Class> _filteredRecords = [];
  List<TagClass> _classTags = [];
  
  // Состояние фильтрации
  String _searchQuery = '';
  List<Tag> _selectedTags = [];
  
  // Состояние сортировки
  SortClassField _sortField = SortClassField.title;
  bool _sortAscending = true;
  
  // Режим выделения
  bool _isSelectionMode = false;
  Set<String> _selectedIds = {};
  
  // Геттеры
  List<Class> get records => _filteredRecords;
  List<TagClass> get classTags => _classTags;
  bool get isSelectionMode => _isSelectionMode;
  Set<String> get selectedIds => _selectedIds;
  String get searchQuery => _searchQuery;
  
  SortClassField get sortField => _sortField;
  bool get sortAscending => _sortAscending;
  
  List<Tag> get selectedTags => _selectedTags;
  
  bool get hasActiveFilters {
    return _searchQuery.isNotEmpty ||
           _selectedTags.isNotEmpty;
  }
  
  // Загрузка данных
  Future loadData() async {
    _records = await _classRepo.getAll();
    _classTags = await _tagClassRepo.getAll();
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
  Future setTagsFilter(List<Tag> tags) async {
    _selectedTags = tags;
    await _applyFiltersAndSort();
    notifyListeners();
  }
  
  void clearAllFilters() {
    _searchQuery = '';
    _selectedTags = [];
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
    if (_selectedTags.isNotEmpty) {
      var selectedTagTasks = _classTags.where((tagTask) => _selectedTags.map((tag) => tag.id).contains(tagTask.tagId));
      result = result.where((task) => selectedTagTasks.map((tagTask) => tagTask.classId).contains(task.id)).toList(); 
    }
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