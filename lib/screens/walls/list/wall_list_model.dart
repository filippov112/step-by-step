import 'package:chaos_control/models/attempt.dart';
import 'package:chaos_control/models/enums/wall_difficulty.dart';
import 'package:chaos_control/models/other/image.dart';
import 'package:chaos_control/models/project.dart';
import 'package:chaos_control/widgets/common/tree_list/tree_list_model.dart';
import 'package:chaos_control/widgets/common/tree_list/tree_record.dart';
import 'package:flutter/material.dart';
import 'package:chaos_control/models/wall.dart';

enum SortWallField { title, difficulty }

class WallListModel extends ChangeNotifier {
  final _wallRepo = WallRepository();
  final _attemptRepo = AttemptRepository();
  final _projectRepo = ProjectRepository();

  List<Wall> _walls = [];
  List<Wall> _filteredWalls = [];
  Map<String,int> attempts = {};
  List<TreeRecord<Wall>> visualList = [];
  List<Project> projects = [];

  final treeListModel = CustomTreeListModel<Wall>();
  
  // Состояние фильтрации
  String searchQuery = '';
  bool visibilitySearch = false;
  bool favoriteFilter = true;
  Project? projectFilter;
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
    await _loadAttempts();
    await _loadProjects();
    await _applyFiltersAndSort();
    notifyListeners();
  }

  Future _loadProjects() async {
    projects = (await _projectRepo.getAll()).where((e) => !e.hidden).toList();
  }

  Future _loadAttempts() async {
    final list = await _attemptRepo.getAll();
    final result = <String,int>{};
    for(var at in list) {
      if (!result.containsKey(at.wallId)) {
        result[at.wallId] = 1;
      } else {
        result[at.wallId] = (result[at.wallId] ?? 0) + 1;
      }
    }
    attempts = result;
  }

  void _reloadList() {
    visualList = treeListModel.openFolder(
      list: transformRecords(), 
      folder: treeListModel.currentFolder,
      groupFilter: groupFilter
    );
  }

  List<TreeRecord<Wall>> transformRecords() => _filteredWalls.map(_buildTreeRecord).toList();

  TreeRecord<Wall> _buildTreeRecord(Wall wall) {
    Project? project; 
    if ( wall.projectId != null && projects.map((p) => p.id).contains(wall.projectId)) {
      project = projects.firstWhere((p) => p.id == wall.projectId);
    }
    return TreeRecord<Wall>(
      address: _buildAddress(wall, project),
      object: wall,
      customIconData: _buildIcon(project),
      name: wall.title,
      color: wall.difficulty.color
    );
  }
  String _buildAddress(Wall wall, Project? project) {
    if (projectFilter != null || wall.projectId == null) {
      return wall.group;
    }
    return [?project?.title, wall.group].join('/');
  }
  CustomImageData _buildIcon(Project? project) {
    return project?.icon ?? CustomImageData.fromIcon(Icons.folder);
  }
  
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
    await _applyFiltersAndSort();
    notifyListeners();
  }
  Future setProjectFilter(Project? value) async {
    projectFilter = value;
    treeListModel.resetAddress();
    await _applyFiltersAndSort();
    notifyListeners();
  }

  Future setGroupFilter(bool value) async {
    groupFilter = value;
    await _applyFiltersAndSort();
    notifyListeners();
  }

  Future clearAllFilters() async {
    searchQuery = '';
    favoriteFilter = true;
    await _applyFiltersAndSort();
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
    if (projectFilter != null) {
      result = result.where((e) => e.projectId == projectFilter!.id).toList();
    }
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
    _reloadList();
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
    await _applyFiltersAndSort();
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
