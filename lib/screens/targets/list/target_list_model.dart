import 'package:chaos_control/models/task.dart';
import 'package:chaos_control/models/other/image.dart';
import 'package:chaos_control/models/project.dart';
import 'package:chaos_control/widgets/common/tree_list/tree_list_model.dart';
import 'package:chaos_control/widgets/common/tree_list/tree_record.dart';
import 'package:flutter/material.dart';
import 'package:chaos_control/models/target.dart';

enum SortTargetField { title }

class TargetListModel extends ChangeNotifier {
  final _targetRepo = TargetRepository();
  final _taskRepo = TaskRepository();
  final _projectRepo = ProjectRepository();

  List<Target> _targets = [];
  List<Target> _filteredTargets = [];
  Map<String,int> tasks = {};
  List<TreeRecord<Target>> visualList = [];
  List<Project> projects = [];

  final treeListModel = CustomTreeListModel<Target>();
  
  // Состояние фильтрации
  String searchQuery = '';
  bool visibilitySearch = false;
  bool favoriteFilter = true;
  Project? projectFilter;
  bool groupFilter = false;

  // Состояние сортировки
  SortTargetField sortField = SortTargetField.title;
  bool sortAscending = true;
  
  // Режим выделения
  bool isSelectionMode = false;
  Set<String> selectedIds = {};
  
  bool get hasActiveFilters {
    return !favoriteFilter || searchQuery.isNotEmpty;
  }
  
  // Загрузка данных
  Future loadData() async {
    _targets = await _targetRepo.getAll();
    await _loadTasks();
    await _loadProjects();
    await _applyFiltersAndSort();
    notifyListeners();
  }

  Future _loadProjects() async {
    projects = (await _projectRepo.getAll()).where((e) => !e.hidden).toList();
  }

  Future _loadTasks() async {
    final list = await _taskRepo.getAll();
    final result = <String,int>{};
    for(var at in list) {
      if (!result.containsKey(at.targetId)) {
        result[at.targetId] = 1;
      } else {
        result[at.targetId] = (result[at.targetId] ?? 0) + 1;
      }
    }
    tasks = result;
  }

  void _reloadList() {
    visualList = treeListModel.openFolder(
      list: transformRecords(), 
      folder: treeListModel.currentFolder,
      groupFilter: groupFilter
    );
  }

  List<TreeRecord<Target>> transformRecords() => _filteredTargets.map(_buildTreeRecord).toList();

  TreeRecord<Target> _buildTreeRecord(Target target) {
    Project? project; 
    if ( target.projectId != null && projects.map((p) => p.id).contains(target.projectId)) {
      project = projects.firstWhere((p) => p.id == target.projectId);
    }
    return TreeRecord<Target>(
      address: _buildAddress(target, project),
      object: target,
      customIconData: _buildIcon(project),
      name: target.title,
    );
  }
  String _buildAddress(Target target, Project? project) {
    if (projectFilter != null || target.projectId == null) {
      return target.group;
    }
    return [?project?.title, target.group].join('/');
  }
  CustomImageData _buildIcon(Project? project) {
    return project?.icon ?? CustomImageData.fromIcon(Icons.folder);
  }
  
  Future openFolder(TreeRecord<Target>? folder) async {
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
  Future setSortField(SortTargetField field) async {
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
    var result = List<Target>.from(_targets);
    // Поиск
    if (searchQuery.isNotEmpty) {
      final query = searchQuery.toLowerCase();
      result = result.where((t) =>
        t.title.toLowerCase().contains(query) ||
        t.desc.toLowerCase().contains(query)
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
      case SortTargetField.title:
        result.sort((a, b) => a.title.compareTo(b.title));
    }
    if (!sortAscending) {
      result = result.reversed.toList();
    }
    _filteredTargets = result;
    _reloadList();
  }
  
  Future update(Target trg) async {
    await _targetRepo.update(trg);
    final index = _targets.indexWhere((t) => t.id == trg.id);
    if (index != -1) {
      _targets[index] = trg;
    }
    await _applyFiltersAndSort();
    notifyListeners();
  }

  Future delete(String id) async {
    await _targetRepo.delete(id);
    _targets.removeWhere((t) => t.id == id);
    selectedIds.remove(id);
    await _applyFiltersAndSort();
    notifyListeners();
  }
  
  Future deleteAllSelected() async {
    for (final id in selectedIds) {
      await _targetRepo.delete(id);
      _targets.removeWhere((t) => t.id == id);
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
    if (selectedIds.length == _filteredTargets.length) {
      selectedIds = {};
    } else {
      selectedIds = _filteredTargets.map((t) => t.id).toSet();
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
