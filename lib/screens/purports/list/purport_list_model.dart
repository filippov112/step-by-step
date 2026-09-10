import 'package:chaos_control/widgets/common/tree_list/tree_list_model.dart';
import 'package:chaos_control/widgets/common/tree_list/tree_record.dart';
import 'package:flutter/material.dart';
import 'package:chaos_control/models/purport.dart';


enum SortPurportField { title }

class PurportListModel extends ChangeNotifier {
  final PurportRepository _purRepo = PurportRepository();

  List<Purport> _purports = [];
  List<Purport> _filteredPurports = [];
  List<TreeRecord<Purport>> purports = [];

  final listModel = CustomTreeListModel<Purport>();
  
  // Состояние фильтрации
  String searchQuery = '';
  bool visibilitySearch = false;
  bool groupFilter = true;

  // Состояние сортировки
  SortPurportField sortField = SortPurportField.title;
  bool sortAscending = true;
  
  // Режим выделения
  bool isSelectionMode = false;
  Set<String> selectedIds = {};
  
  bool get hasActiveFilters {
    return searchQuery.isNotEmpty;
  }
  
  // Загрузка данных
  Future loadData() async {
    _purports = await _purRepo.getAll();
    await _applyFiltersAndSort();
    notifyListeners();
  }

  List<TreeRecord<Purport>> transformRecords() => _filteredPurports
    .map(
      (e) => TreeRecord<Purport>(
        address: e.group,
        object: e,
        name: e.title,
      ),
    )
    .toList();
  
  Future openFolder(TreeRecord<Purport>? folder) async {
    purports = listModel.openFolder(list: transformRecords(), folder: folder);
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
  void setVisibilitySearch(bool value) {
    visibilitySearch = value;
    notifyListeners();
  }
  Future setGroupFilter(bool value) async {
    groupFilter = value;
    _applyFiltersAndSort();
    notifyListeners();
  }
  void clearAllFilters() {
    searchQuery = '';
    _applyFiltersAndSort();
    notifyListeners();
  }
  
  // Сортировка
  Future setSortField(SortPurportField field) async {
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
    var result = List<Purport>.from(_purports);
    // Поиск
    if (searchQuery.isNotEmpty) {
      final query = searchQuery.toLowerCase();
      result = result.where((t) =>
        t.title.toLowerCase().contains(query) ||
        t.description.toLowerCase().contains(query)
      ).toList();
    }
    // Сортировка
    switch (sortField) {
      case SortPurportField.title:
        result.sort((a, b) => a.title.compareTo(b.title));
        break;
    }
    if (!sortAscending) {
      result = result.reversed.toList();
    }
    _filteredPurports = result;
    purports = listModel.openFolder(
      list: transformRecords(), 
      folder: listModel.currentFolder,
      groupFilter: groupFilter
    );
  }
  
  Future update(Purport cls) async {
    await _purRepo.update(cls);
    final index = _purports.indexWhere((t) => t.id == cls.id);
    if (index != -1) {
      _purports[index] = cls;
    }
    await _applyFiltersAndSort();
    notifyListeners();
  }

  Future delete(String id) async {
    await _purRepo.delete(id);
    _purports.removeWhere((t) => t.id == id);
    selectedIds.remove(id);
    _applyFiltersAndSort();
    notifyListeners();
  }
  
  Future deleteAllSelected() async {
    for (final id in selectedIds) {
      await _purRepo.delete(id);
      _purports.removeWhere((t) => t.id == id);
    }
    selectedIds.clear();
    isSelectionMode = false;
    await _applyFiltersAndSort();
    notifyListeners();
  }
  
  // Режим выделения
  void toggleSelectionMode() {
    isSelectionMode = !isSelectionMode;
    if (!isSelectionMode) {
      selectedIds = {};
    }
    notifyListeners();
  }
  
  void toggleSelectAll() {
    if (selectedIds.length == _filteredPurports.length) {
      selectedIds = {};
    } else {
      selectedIds = _filteredPurports.map((t) => t.id).toSet();
    }
    notifyListeners();
  }
  
  void toggleSelect(String id) {
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
}