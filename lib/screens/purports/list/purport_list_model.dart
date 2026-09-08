import 'package:flutter/material.dart';
import 'package:chaos_control/models/purport.dart';
import 'package:chaos_control/models/enums/purport_type.dart';


enum SortPurportField { title, datetime, rarity }
enum FilterStatusValue { received, blocked }

class PurportListModel extends ChangeNotifier {
  final PurportRepository _purportRepo = PurportRepository();

  List<Purport> _allPurports = [];
  List<Purport> _filteredPurports = [];
  
  // Состояние фильтрации
  String _searchQuery = '';
  final Set<PurportType> _filterRar = <PurportType>{};
  final Set<FilterStatusValue> _filterStatus = <FilterStatusValue>{};
  
  // Состояние сортировки
  SortPurportField _sortField = SortPurportField.title;
  bool _sortAscending = true;
  
  // Режим выделения
  bool _isSelectionMode = false;
  Set<String> _selectedIds = {};
  
  // Геттеры
  List<Purport> get purports => _filteredPurports;
  bool get isSelectionMode => _isSelectionMode;
  Set<String> get selectedIds => _selectedIds;
  String get searchQuery => _searchQuery;
  
  SortPurportField get sortField => _sortField;
  bool get sortAscending => _sortAscending;
  
  Set<PurportType> get filterRarity => _filterRar;
  Set<FilterStatusValue> get filterStatus => _filterStatus;
  
  bool get hasActiveFilters {
    return _searchQuery.isNotEmpty ||
           _filterRar.isNotEmpty ||
           _filterStatus.isNotEmpty;
  }
  
  // Загрузка данных
  Future loadPurports() async {
    _allPurports = await _purportRepo.getAll();
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
  Future setRarityFilter(PurportType rang) async {
    if (_filterRar.contains(rang)) {
      _filterRar.remove(rang);
    } else {
      _filterRar.add(rang);
    }
    await _applyFiltersAndSort();
    notifyListeners();
  }


  Future setStatusFilter(FilterStatusValue status) async {
    if (_filterStatus.contains(status)) {
      _filterStatus.remove(status);
    } else {
      _filterStatus.add(status);
    }
    await _applyFiltersAndSort();
    notifyListeners();
  }
  
  
  void clearAllFilters() {
    _searchQuery = '';
    _filterRar.clear();
    _filterStatus.clear();
    _applyFiltersAndSort();
    notifyListeners();
  }
  
  // Сортировка
  Future setSortField(SortPurportField field) async {
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
    var result = List<Purport>.from(_allPurports);
    // Поиск
    if (_searchQuery.isNotEmpty) {
      final query = _searchQuery.toLowerCase();
      result = result.where((t) =>
        t.title.toLowerCase().contains(query) ||
        t.description.toLowerCase().contains(query)
      ).toList();
    }
    // Фильтры
    if (_filterRar.isNotEmpty) {
      result = result.where((t) => _filterRar.contains(t.type)).toList();
    }
    if (_filterStatus.isNotEmpty) {
      result = result.where((t) => _filterStatus.contains(t.date == null ? FilterStatusValue.blocked : FilterStatusValue.received)).toList();
    }
    // Сортировка
    switch (_sortField) {
      case SortPurportField.title:
        result.sort((a, b) => a.title.compareTo(b.title));
        break;
      case SortPurportField.datetime:
        result.sort((a, b) {
          if (a.date == null && b.date == null) return 0;
          if (a.date == null && b.date != null) return -1;
          if (a.date != null && b.date == null) return 1;
          if (a.date != null && b.date != null) return a.date!.compareTo(b.date!);
          return 0;
        });
        break;
      case SortPurportField.rarity:
        result.sort((a, b) => a.type.index.compareTo(b.type.index));
        break;
    }
    if (!_sortAscending) {
      result = result.reversed.toList();
    }
    _filteredPurports = result;
  }
  
  Future updatePurport(Purport purport) async {
    await _purportRepo.update(purport);
    final index = _allPurports.indexWhere((t) => t.id == purport.id);
    if (index != -1) {
      _allPurports[index] = purport;
    }
    await _applyFiltersAndSort();
    notifyListeners();
  }

  Future deletePurport(String id) async {
    await _purportRepo.delete(id);
    _allPurports.removeWhere((t) => t.id == id);
    _selectedIds.remove(id);
    _applyFiltersAndSort();
    notifyListeners();
  }
  
  Future deleteSelectedPurports() async {
    for (final id in _selectedIds) {
      await _purportRepo.delete(id);
      _allPurports.removeWhere((t) => t.id == id);
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
    if (_selectedIds.length == _filteredPurports.length) {
      _selectedIds.clear();
    } else {
      _selectedIds = _filteredPurports.map((t) => t.id).toSet();
    }
    notifyListeners();
  }
  
  void toggleSelectPurport(String id) {
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