import 'package:chaos_control/widgets/common/tree_list/tree_list_model.dart';
import 'package:chaos_control/widgets/common/tree_list/tree_record.dart';
import 'package:flutter/material.dart';
import 'package:chaos_control/models/wall.dart';

enum SortWallField { title, difficulty }

class WallListModel extends ChangeNotifier {
  final _wallRepo = WallRepository();

  List<Wall> _walls = [];
  List<Wall> _filteredWalls = [];
  List<TreeRecord<Wall>> visualList = [];

  final treeListModel = CustomTreeListModel<Wall>();
  
  // Состояние фильтрации
  String searchQuery = '';
  bool visibilitySearch = false;
  bool favoriteFilter = true;
  bool groupFilter = false;

  // Состояние сортировки
  SortWallField sortField = SortWallField.title;
  bool sortAscending = true;
  
  // Режим выделения
  bool isSelectionMode = false;
  Set<String> selectedIds = {};
  
  bool get hasActiveFilters {
    return !favoriteFilter || searchQuery.isNotEmpty;
  }
  
  // Загрузка данных
  Future loadData() async {
    _walls = await _wallRepo.getAll();
    await _applyFiltersAndSort();
    notifyListeners();
  }

  List<TreeRecord<Wall>> transformRecords() => _filteredWalls
    .map(
      (e) => TreeRecord<Wall>(
        address: e.group,
        object: e,
        name: e.title,
      ),
    )
    .toList();
  
  Future openFolder(TreeRecord<Wall>? folder) async {
    visualList = treeListModel.openFolder(list: transformRecords(), folder: folder);
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
  Future setFavoriteFilter(bool value) async {
    favoriteFilter = value;
    _applyFiltersAndSort();
    notifyListeners();
  }

  Future setGroupFilter(bool value) async {
    groupFilter = value;
    _applyFiltersAndSort();
    notifyListeners();
  }

  void clearAllFilters() {
    searchQuery = '';
    favoriteFilter = true;
    _applyFiltersAndSort();
    notifyListeners();
  }
  
  // Сортировка
  Future setSortField(SortWallField field) async {
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
    var result = List<Wall>.from(_walls);
    // Поиск
    if (searchQuery.isNotEmpty) {
      final query = searchQuery.toLowerCase();
      result = result.where((t) =>
        t.title.toLowerCase().contains(query) ||
        t.target.toLowerCase().contains(query)
      ).toList();
    }
    // Фильтры
    if (favoriteFilter) {
      result = result.where((e) => e.favorite).toList();
    }
    // Сортировка
    switch (sortField) {
      case SortWallField.title:
        result.sort((a, b) => a.title.compareTo(b.title));
      case SortWallField.difficulty:
        result.sort((a, b) => a.difficulty.index - b.difficulty.index);
    }
    if (!sortAscending) {
      result = result.reversed.toList();
    }
    _filteredWalls = result;
    visualList = treeListModel.openFolder(
      list: transformRecords(), 
      folder: treeListModel.currentFolder,
      groupFilter: groupFilter
    );
  }
  
  Future update(Wall wll) async {
    await _wallRepo.update(wll);
    final index = _walls.indexWhere((t) => t.id == wll.id);
    if (index != -1) {
      _walls[index] = wll;
    }
    await _applyFiltersAndSort();
    notifyListeners();
  }

  Future delete(String id) async {
    await _wallRepo.delete(id);
    _walls.removeWhere((t) => t.id == id);
    selectedIds.remove(id);
    _applyFiltersAndSort();
    notifyListeners();
  }
  
  Future deleteAllSelected() async {
    for (final id in selectedIds) {
      await _wallRepo.delete(id);
      _walls.removeWhere((t) => t.id == id);
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
    if (selectedIds.length == _filteredWalls.length) {
      selectedIds = {};
    } else {
      selectedIds = _filteredWalls.map((t) => t.id).toSet();
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
