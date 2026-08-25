import 'package:flutter/material.dart';
import 'package:chaos_control/models/achievement.dart';
import 'package:chaos_control/models/enums/achiev_rar.dart';
import 'package:chaos_control/models/tag.dart';
import 'package:chaos_control/models/tag_achievement.dart';


enum SortAchievementField { title, datetime, rarity }
enum FilterStatusValue { received, blocked }

class AchievementListModel extends ChangeNotifier {
  final AchievementRepository _achiRepo = AchievementRepository();
  final TagAchievementRepository _tagAchiRepo = TagAchievementRepository();

  List<Achievement> _allAchievements = [];
  List<Achievement> _filteredAchievements = [];
  List<TagAchievement> _allTagAchievements = [];
  
  // Состояние фильтрации
  String _searchQuery = '';
  final Set<AchievRar> _filterRar = <AchievRar>{};
  final Set<FilterStatusValue> _filterStatus = <FilterStatusValue>{};
  List<Tag> _selectedTags = [];
  
  // Состояние сортировки
  SortAchievementField _sortField = SortAchievementField.title;
  bool _sortAscending = true;
  
  // Режим выделения
  bool _isSelectionMode = false;
  Set<String> _selectedIds = {};
  
  // Геттеры
  List<Achievement> get achievements => _filteredAchievements;
  List<TagAchievement> get allTags => _allTagAchievements;
  bool get isSelectionMode => _isSelectionMode;
  Set<String> get selectedIds => _selectedIds;
  String get searchQuery => _searchQuery;
  
  SortAchievementField get sortField => _sortField;
  bool get sortAscending => _sortAscending;
  
  Set<AchievRar> get filterRarity => _filterRar;
  Set<FilterStatusValue> get filterStatus => _filterStatus;
  List<Tag> get selectedTags => _selectedTags;
  
  bool get hasActiveFilters {
    return _searchQuery.isNotEmpty ||
           _filterRar.isNotEmpty ||
           _selectedTags.isNotEmpty ||
           _filterStatus.isNotEmpty;
  }
  
  // Загрузка данных
  Future loadAchievements() async {
    _allAchievements = await _achiRepo.getAll();
    _allTagAchievements = await _tagAchiRepo.getAll();
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
  Future setRarityFilter(AchievRar rang) async {
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
  
  
  Future setTagsFilter(List<Tag> tags) async {
    _selectedTags = tags;
    await _applyFiltersAndSort();
    notifyListeners();
  }
  
  void clearAllFilters() {
    _searchQuery = '';
    _filterRar.clear();
    _filterStatus.clear();
    _selectedTags = [];
    _applyFiltersAndSort();
    notifyListeners();
  }
  
  // Сортировка
  Future setSortField(SortAchievementField field) async {
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
    var result = List<Achievement>.from(_allAchievements);
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
      result = result.where((t) => _filterRar.contains(t.rarity)).toList();
    }
    if (_filterStatus.isNotEmpty) {
      result = result.where((t) => _filterStatus.contains(t.date == null ? FilterStatusValue.blocked : FilterStatusValue.received)).toList();
    }
    if (_selectedTags.isNotEmpty) {
      var selectedTagTasks = _allTagAchievements.where((tagTask) => _selectedTags.map((tag) => tag.id).contains(tagTask.tagId));
      result = result.where((task) => selectedTagTasks.map((tagTask) => tagTask.achievementId).contains(task.id)).toList(); 
    }
    // Сортировка
    switch (_sortField) {
      case SortAchievementField.title:
        result.sort((a, b) => a.title.compareTo(b.title));
        break;
      case SortAchievementField.datetime:
        result.sort((a, b) {
          if (a.date == null && b.date == null) return 0;
          if (a.date == null && b.date != null) return -1;
          if (a.date != null && b.date == null) return 1;
          if (a.date != null && b.date != null) return a.date!.compareTo(b.date!);
          return 0;
        });
        break;
      case SortAchievementField.rarity:
        result.sort((a, b) => a.rarity.index.compareTo(b.rarity.index));
        break;
    }
    if (!_sortAscending) {
      result = result.reversed.toList();
    }
    _filteredAchievements = result;
  }
  
  Future updateAchievement(Achievement ach) async {
    await _achiRepo.update(ach);
    final index = _allAchievements.indexWhere((t) => t.id == ach.id);
    if (index != -1) {
      _allAchievements[index] = ach;
    }
    await _applyFiltersAndSort();
    notifyListeners();
  }

  Future deleteAchievement(String id) async {
    await _achiRepo.delete(id);
    _allAchievements.removeWhere((t) => t.id == id);
    _selectedIds.remove(id);
    _applyFiltersAndSort();
    notifyListeners();
  }
  
  Future deleteSelectedAchievements() async {
    for (final id in _selectedIds) {
      await _achiRepo.delete(id);
      _allAchievements.removeWhere((t) => t.id == id);
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
    if (_selectedIds.length == _filteredAchievements.length) {
      _selectedIds.clear();
    } else {
      _selectedIds = _filteredAchievements.map((t) => t.id).toSet();
    }
    notifyListeners();
  }
  
  void toggleSelectAchievement(String id) {
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