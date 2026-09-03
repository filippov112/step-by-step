import 'package:chaos_control/widgets/common/tree_list/tree_list_model.dart';
import 'package:chaos_control/widgets/common/tree_list/tree_record.dart';
import 'package:flutter/material.dart';
import 'package:chaos_control/models/project.dart';


enum SortProjectField { title }

class ProjectListModel extends ChangeNotifier {
  final ProjectRepository _classRepo = ProjectRepository();

  List<Project> _projects = [];
  List<Project> _filteredProjects = [];
  List<TreeRecord<Project>> visualList = [];

  final treeListModel = CustomTreeListModel<Project>();
  
  // Состояние фильтрации
  String searchQuery = '';
  bool visibilitySearch = false;
  bool showHiddenFilter = false;
  bool groupFilter = true;

  // Состояние сортировки
  SortProjectField sortField = SortProjectField.title;
  bool sortAscending = true;
  
  // Режим выделения
  bool isSelectionMode = false;
  Set<String> selectedIds = {};
  
  bool get hasActiveFilters {
    return showHiddenFilter || searchQuery.isNotEmpty;
  }
  
  // Загрузка данных
  Future loadData() async {
    _projects = await _classRepo.getAll();
    await _applyFiltersAndSort();
    notifyListeners();
  }

  List<TreeRecord<Project>> transformRecords() => _filteredProjects
    .map(
      (e) => TreeRecord<Project>(
        address: e.group,
        object: e,
        name: e.title,
        customIconData: e.icon
      ),
    )
    .toList();
  
  Future openFolder(TreeRecord<Project>? folder) async {
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
  Future setHiddenFilter(bool value) async {
    showHiddenFilter = value;
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
    showHiddenFilter = false;
    _applyFiltersAndSort();
    notifyListeners();
  }
  
  // Сортировка
  Future setSortField(SortProjectField field) async {
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
    var result = List<Project>.from(_projects);
    // Поиск
    if (searchQuery.isNotEmpty) {
      final query = searchQuery.toLowerCase();
      result = result.where((t) =>
        t.title.toLowerCase().contains(query) ||
        t.target.toLowerCase().contains(query)
      ).toList();
    }
    // Фильтры
    if (!showHiddenFilter) {
      result = result.where((e) => !e.hidden).toList();
    }
    // Сортировка
    switch (sortField) {
      case SortProjectField.title:
        result.sort((a, b) => a.title.compareTo(b.title));
        break;
    }
    if (!sortAscending) {
      result = result.reversed.toList();
    }
    _filteredProjects = result;
    visualList = treeListModel.openFolder(
      list: transformRecords(), 
      folder: treeListModel.currentFolder,
      groupFilter: groupFilter
    );
  }
  
  Future update(Project cls) async {
    await _classRepo.update(cls);
    final index = _projects.indexWhere((t) => t.id == cls.id);
    if (index != -1) {
      _projects[index] = cls;
    }
    await _applyFiltersAndSort();
    notifyListeners();
  }

  Future delete(String id) async {
    await _classRepo.delete(id);
    _projects.removeWhere((t) => t.id == id);
    selectedIds.remove(id);
    _applyFiltersAndSort();
    notifyListeners();
  }
  
  Future deleteAllSelected() async {
    for (final id in selectedIds) {
      await _classRepo.delete(id);
      _projects.removeWhere((t) => t.id == id);
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
    if (selectedIds.length == _filteredProjects.length) {
      selectedIds = {};
    } else {
      selectedIds = _filteredProjects.map((t) => t.id).toSet();
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