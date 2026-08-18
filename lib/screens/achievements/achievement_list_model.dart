import 'dart:io';
import 'package:flutter/material.dart';
import 'package:life_game/models/achievement.dart';
import 'package:life_game/models/enums/achiev_rar.dart';
import 'package:life_game/models/tag.dart';
import 'package:life_game/models/tag_achievement.dart';
import 'package:life_game/services/file_storage_service.dart';


class AchievementListModel extends ChangeNotifier {
  final AchievementRepository _achiRepo = AchievementRepository();
  final TagRepository _tagRepo = TagRepository();
  final TagAchievementRepository _tagAchiRepo = TagAchievementRepository();

  List<Achievement> _allAchievements = [];
  List<Achievement> _filteredAchievements = [];
  List<TagAchievement> _allTagAchievements = [];
  
  // Состояние фильтрации
  String _searchQuery = '';
  final Set<AchievRar> _filterRar = <AchievRar>{};
  List<Tag> _selectedTags = [];
  
  // Состояние сортировки
  SortAchievementField _sortField = SortAchievementField.title;
  bool _sortAscending = true;
  
  // Режим выделения
  bool _isSelectionMode = false;
  Set<String> _selectedIds = {};
  
  // Геттеры
  List<Achievement> get Achievements => _filteredAchievements;
  List<TagAchievement> get allTags => _allTagAchievements;
  bool get isSelectionMode => _isSelectionMode;
  Set<String> get selectedIds => _selectedIds;
  String get searchQuery => _searchQuery;
  
  SortAchievementField get sortField => _sortField;
  bool get sortAscending => _sortAscending;
  
  Set<AchievRar> get filterRang => _filterRar;
  List<Tag> get selectedTags => _selectedTags;
  
  bool get hasActiveFilters {
    return _searchQuery.isNotEmpty ||
           _filterRar.isNotEmpty ||
           _selectedTags.isNotEmpty;
  }
  
  // Загрузка данных
  Future loadAchievements() async {
    _allAchievements = await _AchievementRepo.getAll();
    _allTagAchievements = await _tagAchievementRepo.getAll();
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
  Future setRangFilter(AchievRar rang) async {
    if (_filterRar.contains(rang)) {
      _filterRar.remove(rang);
    } else {
      _filterRar.add(rang);
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
        t.title.toLowerCase().contains(query)
      ).toList();
    }
    // Фильтры по приоритету и сложности
    if (_filterRar.isNotEmpty) {
      result = result.where((t) => _filterRar.contains(t.rang)).toList();
    }
    // Фильтр по тегам
    if (_selectedTags.isNotEmpty) {
      var selectedTagTasks = _allTagAchievements.where((tagTask) => _selectedTags.map((tag) => tag.id).contains(tagTask.tagId));
      result = result.where((task) => selectedTagTasks.map((tagTask) => tagTask.AchievementId).contains(task.id)).toList(); 
    }
    // Сортировка
    switch (_sortField) {
      case SortAchievementField.title:
        result.sort((a, b) => a.title.compareTo(b.title));
        break;
      case SortAchievementField.rang:
        result.sort((a, b) => a.rang.index.compareTo(b.rang.index));
        break;
      case SortAchievementField.level:
        result.sort((a, b) => a.level.compareTo(b.level));
        break;
    }
    if (!_sortAscending) {
      result = result.reversed.toList();
    }
    _filteredAchievements = result;
  }
  
  Future updateAchievement(Achievement Achievement) async {
    await _AchievementRepo.update(Achievement);
    final index = _allAchievements.indexWhere((t) => t.id == Achievement.id);
    if (index != -1) {
      _allAchievements[index] = Achievement;
    }
    await _applyFiltersAndSort();
    notifyListeners();
  }

  Future deleteAchievement(String id) async {
    await _AchievementRepo.delete(id);
    _allAchievements.removeWhere((t) => t.id == id);
    _selectedIds.remove(id);
    _applyFiltersAndSort();
    notifyListeners();
  }
  
  Future deleteSelectedAchievements() async {
    for (final id in _selectedIds) {
      await _AchievementRepo.delete(id);
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