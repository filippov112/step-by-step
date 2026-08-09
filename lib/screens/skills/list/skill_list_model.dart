import 'package:flutter/material.dart';
import 'package:life_game/models/skill.dart';
import 'package:life_game/models/skill_condition.dart';
import 'package:life_game/services/file_storage_service.dart';

class SkillListModel extends ChangeNotifier {
  final SkillRepository _skillRepo = SkillRepository();
  final SkillConditionRepository _conditionRepo = SkillConditionRepository();
  final FileStorageService _fileStorage = FileStorageService();
  
  List<Skill> _skills = [];
  bool _isLoading = false;
  String? _error;
  
  List<Skill> get skills => _skills;
  bool get isLoading => _isLoading;
  String? get error => _error;
  
  // Загрузка всех навыков
  Future<void> loadSkills() async {
    _isLoading = true;
    _error = null;
    notifyListeners();
    
    try {
      _skills = await _skillRepo.getAll();
      // Сортируем по рангу (от F к EX)
      _skills.sort((a, b) => a.rang.index.compareTo(b.rang.index));
    } catch (e) {
      _error = 'Ошибка загрузки навыков: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
  
  // Удаление навыка
  Future<bool> deleteSkill(String id) async {
    try {
      // Сначала удаляем все условия для этого навыка
      final conditions = await _conditionRepo.getAll();
      final skillConditions = conditions.where((c) => c.skillId == id);
      for (var condition in skillConditions) {
        await _conditionRepo.delete(condition.id);
      }
      
      // Удаляем сам навык
      await _skillRepo.delete(id);
      
      // Обновляем список
      _skills.removeWhere((s) => s.id == id);
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