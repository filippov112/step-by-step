import 'package:flutter/material.dart';
import 'package:life_game/models/enums/skill_rang.dart';
import 'package:life_game/models/skill.dart';
import 'package:life_game/models/tag.dart';
import 'package:life_game/models/tag_skill.dart';
import 'package:life_game/screens/skills/list/widgets/filters.dart';


class SkillListModel extends ChangeNotifier {
  final SkillRepository _skillRepo = SkillRepository();
  final TagSkillRepository _tagSkillRepo = TagSkillRepository();

  
  List<Skill> _allSkills = [];
  List<Skill> _filteredSkills = [];
  List<TagSkill> _allTagSkills = [];
  
  // Состояние фильтрации
  String _searchQuery = '';
  final Set<SkillRang> _filterRang = <SkillRang>{};
  List<Tag> _selectedTags = [];
  
  // Состояние сортировки
  SortSkillField _sortField = SortSkillField.title;
  bool _sortAscending = true;
  
  // Режим выделения
  bool _isSelectionMode = false;
  Set<String> _selectedIds = {};
  
  // Геттеры
  List<Skill> get skills => _filteredSkills;
  List<TagSkill> get allTags => _allTagSkills;
  bool get isSelectionMode => _isSelectionMode;
  Set<String> get selectedIds => _selectedIds;
  String get searchQuery => _searchQuery;
  
  SortSkillField get sortField => _sortField;
  bool get sortAscending => _sortAscending;
  
  Set<SkillRang> get filterRang => _filterRang;
  List<Tag> get selectedTags => _selectedTags;
  
  bool get hasActiveFilters {
    return _searchQuery.isNotEmpty ||
           _filterRang.isNotEmpty ||
           _selectedTags.isNotEmpty;
  }
  
  // Загрузка данных
  Future loadSkills() async {
    _allSkills = await _skillRepo.getAll();
    _allTagSkills = await _tagSkillRepo.getAll();
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
  Future setRangFilter(SkillRang rang) async {
    if (_filterRang.contains(rang)) {
      _filterRang.remove(rang);
    } else {
      _filterRang.add(rang);
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
    _filterRang.clear();
    _selectedTags = [];
    _applyFiltersAndSort();
    notifyListeners();
  }
  
  // Сортировка
  Future setSortField(SortSkillField field) async {
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
    var result = List<Skill>.from(_allSkills);
    // Поиск
    if (_searchQuery.isNotEmpty) {
      final query = _searchQuery.toLowerCase();
      result = result.where((t) =>
        t.title.toLowerCase().contains(query)
      ).toList();
    }
    // Фильтры по приоритету и сложности
    if (_filterRang.isNotEmpty) {
      result = result.where((t) => _filterRang.contains(t.rang)).toList();
    }
    // Фильтр по тегам
    if (_selectedTags.isNotEmpty) {
      var selectedTagTasks = _allTagSkills.where((tagTask) => _selectedTags.map((tag) => tag.id).contains(tagTask.tagId));
      result = result.where((task) => selectedTagTasks.map((tagTask) => tagTask.skillId).contains(task.id)).toList(); 
    }
    // Сортировка
    switch (_sortField) {
      case SortSkillField.title:
        result.sort((a, b) => a.title.compareTo(b.title));
        break;
      case SortSkillField.rang:
        result.sort((a, b) => a.rang.index.compareTo(b.rang.index));
        break;
      case SortSkillField.level:
        result.sort((a, b) => a.experience.compareTo(b.experience));
        break;
    }
    if (!_sortAscending) {
      result = result.reversed.toList();
    }
    _filteredSkills = result;
  }
  
  Future updateSkill(Skill skill) async {
    await _skillRepo.update(skill);
    final index = _allSkills.indexWhere((t) => t.id == skill.id);
    if (index != -1) {
      _allSkills[index] = skill;
    }
    await _applyFiltersAndSort();
    notifyListeners();
  }

  Future deleteSkill(String id) async {
    await _skillRepo.delete(id);
    _allSkills.removeWhere((t) => t.id == id);
    _selectedIds.remove(id);
    _applyFiltersAndSort();
    notifyListeners();
  }
  
  Future deleteSelectedSkills() async {
    for (final id in _selectedIds) {
      await _skillRepo.delete(id);
      _allSkills.removeWhere((t) => t.id == id);
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
    if (_selectedIds.length == _filteredSkills.length) {
      _selectedIds.clear();
    } else {
      _selectedIds = _filteredSkills.map((t) => t.id).toSet();
    }
    notifyListeners();
  }
  
  void toggleSelectSkill(String id) {
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