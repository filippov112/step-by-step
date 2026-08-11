import 'package:flutter/material.dart';
import 'package:life_game/models/skill.dart';
import 'package:life_game/models/skill_condition.dart';
import 'package:life_game/models/tag.dart';
import 'package:life_game/models/tag_skill.dart';

class SkillListModel extends ChangeNotifier {

  final SkillRepository _skillRepo = SkillRepository();
  final SkillConditionRepository _conditionRepo = SkillConditionRepository();
  final TagRepository _tagRepo = TagRepository();
  final TagSkillRepository _tagSkillRepo = TagSkillRepository();
  
  List<Skill> _skills = [];
  List<Tag> _allTags = [];
  final Map<String, List<Tag>> _skillTags = {};
  bool _isLoading = false;
  String? _error;
  
  List<Skill> get skills => _skills;
  List<Tag> get allTags => _allTags;
  bool get isLoading => _isLoading;
  String? get error => _error;
  
  // Загрузка всех навыков
  Future<void> loadSkills() async {
    _isLoading = true;
    _error = null;
    notifyListeners();
    
    try {
      _skills = await _skillRepo.getAll();
      _skills.sort((a, b) => a.rang.index.compareTo(b.rang.index));
      
      // Загружаем теги для каждого навыка
      await _loadSkillTags();
    } catch (e) {
      _error = 'Ошибка загрузки навыков: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
  
  // Загрузка всех тегов
  Future<void> loadTags() async {
    try {
      _allTags = await _tagRepo.getAll();
      _allTags.sort((a, b) => a.title.compareTo(b.title));
      notifyListeners();
    } catch (e) {
      _error = 'Ошибка загрузки тегов: $e';
    }
  }
  
  // Загрузка тегов для навыков
  Future<void> _loadSkillTags() async {
    _skillTags.clear();
    final allTagSkills = await _tagSkillRepo.getAll();
    
    for (var skill in _skills) {
      final tagIds = allTagSkills
          .where((ts) => ts.skillId == skill.id)
          .map((ts) => ts.tagId)
          .toList();
      
      final tags = _allTags.where((tag) => tagIds.contains(tag.id)).toList();
      _skillTags[skill.id] = tags;
    }
  }
  
  // Получение тегов для навыка
  List<Tag> getSkillTags(String skillId) {
    return _skillTags[skillId] ?? [];
  }
  
  // Удаление навыка
  Future<bool> deleteSkill(String id) async {
    try {
      final conditions = await _conditionRepo.getAll();
      final skillConditions = conditions.where((c) => c.skillId == id);
      for (var condition in skillConditions) {
        await _conditionRepo.delete(condition.id);
      }
      
      final tagSkills = await _tagSkillRepo.getAll();
      final skillTagSkills = tagSkills.where((ts) => ts.skillId == id);
      for (var ts in skillTagSkills) {
        await _tagSkillRepo.delete(ts.skillId, ts.tagId);
      }
      
      await _skillRepo.delete(id);
      
      _skills.removeWhere((s) => s.id == id);
      _skillTags.remove(id);
      notifyListeners();
      return true;
    } catch (e) {
      _error = 'Ошибка удаления навыка: $e';
      notifyListeners();
      return false;
    }
  }
  
  // Получение навыка по ID
  Skill? getSkillById(String id) {
    try {
      return _skills.firstWhere((s) => s.id == id);
    } catch (e) {
      return null;
    }
  }
}