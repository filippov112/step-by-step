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
  String _searchQuery = '';

  // Состояние сортировки
  SortProjectField _sortField = SortProjectField.title;
  bool _sortAscending = true;
  
  // Режим выделения
  bool _isSelectionMode = false;
  Set<String> _selectedIds = {};
  
  // Геттеры
  List<Project> get projects => _filteredProjects;
  bool get isSelectionMode => _isSelectionMode;
  Set<String> get selectedIds => _selectedIds;
  String get searchQuery => _searchQuery;
  
  SortProjectField get sortField => _sortField;
  bool get sortAscending => _sortAscending;
  
  
  bool get hasActiveFilters {
    return _searchQuery.isNotEmpty;
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
      ),
    )
    .toList();
  
  Future openFolder(TreeRecord<Project>? folder) async {
    visualList = treeListModel.openFolder(list: transformRecords(), folder: folder);
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
  Future setSortField(SortProjectField field) async {
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
    var result = List<Project>.from(_projects);
    // Поиск
    if (_searchQuery.isNotEmpty) {
      final query = _searchQuery.toLowerCase();
      result = result.where((t) =>
        t.title.toLowerCase().contains(query) ||
        t.target.toLowerCase().contains(query)
      ).toList();
    }
    // Фильтры
    // Сортировка
    switch (_sortField) {
      case SortProjectField.title:
        result.sort((a, b) => a.title.compareTo(b.title));
        break;
    }
    if (!_sortAscending) {
      result = result.reversed.toList();
    }
    _filteredProjects = result;
    visualList = treeListModel.openFolder(
      list: transformRecords(), 
      folder: treeListModel.currentFolder
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
    _selectedIds.remove(id);
    _applyFiltersAndSort();
    notifyListeners();
  }
  
  Future deleteAllSelected() async {
    for (final id in _selectedIds) {
      await _classRepo.delete(id);
      _projects.removeWhere((t) => t.id == id);
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
    if (_selectedIds.length == _filteredProjects.length) {
      _selectedIds.clear();
    } else {
      _selectedIds = _filteredProjects.map((t) => t.id).toSet();
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