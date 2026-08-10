// lib/screens/skills/skill_detail_view_model.dart
import 'package:flutter/material.dart';
import 'package:life_game/models/skill.dart';
import 'package:life_game/models/skill_condition.dart';
import 'package:life_game/models/enums/skill_rang.dart';

class SkillDetailModel extends ChangeNotifier {
  final SkillRepository _skillRepo = SkillRepository();
  final SkillConditionRepository _conditionRepo = SkillConditionRepository();
  
  Skill? _skill;
  List<SkillCondition> _conditions = [];
  Map<String, bool> _completedConditions = {};
  bool _isLoading = false;
  String? _error;
  
  Skill? get skill => _skill;
  List<SkillCondition> get conditions => _conditions;
  Map<String, bool> get completedConditions => _completedConditions;
  bool get isLoading => _isLoading;
  String? get error => _error;
  
  // Загрузка данных навыка
  Future<void> loadSkill(String skillId) async {
    _isLoading = true;
    _error = null;
    _skill = null;
    _conditions = [];
    _completedConditions = {};
    notifyListeners();
    
    try {
      _skill = await _skillRepo.get(skillId);
      if (_skill != null) {
        // Загружаем условия для этого навыка
        final allConditions = await _conditionRepo.getAll();
        _conditions = allConditions.where((c) => c.skillId == skillId).toList();
        _conditions.sort((a, b) => a.rang.index.compareTo(b.rang.index));
        
        // Инициализируем статус выполнения условий
        for (var condition in _conditions) {
          _completedConditions[condition.id] = condition.date != null;
        }
      } else {
        _error = 'Навык не найден';
      }
    } catch (e) {
      _error = 'Ошибка загрузки навыка: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
  
  // Переключение статуса выполнения условия
  Future<void> toggleConditionCompletion(String conditionId) async {
    final condition = _conditions.firstWhere((c) => c.id == conditionId);
    final isCompleted = _completedConditions[conditionId] ?? false;
    
    try {
      if (isCompleted) {
        // Снимаем отметку о выполнении
        final updatedCondition = SkillCondition(
          id: condition.id,
          rang: condition.rang,
          skillId: condition.skillId,
          description: condition.description,
          date: null,
        );
        await _conditionRepo.update(updatedCondition);
        _completedConditions[conditionId] = false;
      } else {
        // Отмечаем как выполненное - ставим текущую дату
        final updatedCondition = SkillCondition(
          id: condition.id,
          rang: condition.rang,
          skillId: condition.skillId,
          description: condition.description,
          date: DateTime.now(),
        );
        await _conditionRepo.update(updatedCondition);
        _completedConditions[conditionId] = true;
      }
      
      // Обновляем список условий
      final index = _conditions.indexWhere((c) => c.id == conditionId);
      if (index != -1) {
        final updated = await _conditionRepo.get(conditionId);
        if (updated != null) {
          _conditions[index] = updated;
        }
      }
      
      notifyListeners();
    } catch (e) {
      _error = 'Ошибка обновления условия: $e';
      notifyListeners();
    }
  }
  
  // Проверка, можно ли повысить ранг
  bool canUpgradeRank() {
    if (_skill == null || _conditions.isEmpty) return false;
    
    final currentRangIndex = _skill!.rang.index;
    if (currentRangIndex >= SkillRang.values.length - 1) return false;
    
    // Проверяем, есть ли выполненные условия для более высокого ранга
    final completedRangs = _conditions
        .where((c) => _completedConditions[c.id] == true)
        .map((c) => c.rang.index)
        .toList();
    
    if (completedRangs.isEmpty) return false;
    
    // Находим максимальный ранг среди выполненных условий
    final maxCompletedRang = completedRangs.reduce((a, b) => a > b ? a : b);
    
    // Повышение доступно, если есть выполненное условие для следующего ранга
    return maxCompletedRang > currentRangIndex;
  }
  
  // Получение следующего ранга для повышения
  SkillRang? getNextRangForUpgrade() {
    if (_skill == null) return null;
    
    final currentRangIndex = _skill!.rang.index;
    if (currentRangIndex >= SkillRang.values.length - 1) return null;
    
    final completedRangs = _conditions
        .where((c) => _completedConditions[c.id] == true)
        .map((c) => c.rang.index)
        .toList();
    
    if (completedRangs.isEmpty) return null;
    
    final maxCompletedRang = completedRangs.reduce((a, b) => a > b ? a : b);
    
    if (maxCompletedRang > currentRangIndex) {
      return SkillRang.values[maxCompletedRang];
    }
    
    return null;
  }
  
  // Повышение ранга навыка
  Future<bool> upgradeRank() async {
    if (_skill == null) return false;
    if (!canUpgradeRank()) return false;
    
    final newRang = getNextRangForUpgrade();
    if (newRang == null) return false;
    
    try {
      final updatedSkill = Skill(
        id: _skill!.id,
        title: _skill!.title,
        rang: newRang,
        level: _skill!.level,
        experience: _skill!.experience,
        icon: _skill!.icon,
        f: _skill!.f,
        e: _skill!.e,
        d: _skill!.d,
        c: _skill!.c,
        b: _skill!.b,
        a: _skill!.a,
        s: _skill!.s,
        ss: _skill!.ss,
        sss: _skill!.sss,
        ex: _skill!.ex,
      );
      
      await _skillRepo.update(updatedSkill);
      _skill = updatedSkill;
      notifyListeners();
      return true;
    } catch (e) {
      _error = 'Ошибка повышения ранга: $e';
      notifyListeners();
      return false;
    }
  }
  
  // Получение описания для ранга
  String? getDescriptionForRang(SkillRang rang) {
    if (_skill == null) return null;
    
    switch (rang) {
      case SkillRang.F:
        return _skill!.f;
      case SkillRang.E:
        return _skill!.e;
      case SkillRang.D:
        return _skill!.d;
      case SkillRang.C:
        return _skill!.c;
      case SkillRang.B:
        return _skill!.b;
      case SkillRang.A:
        return _skill!.a;
      case SkillRang.S:
        return _skill!.s;
      case SkillRang.SS:
        return _skill!.ss;
      case SkillRang.SSS:
        return _skill!.sss;
      case SkillRang.EX:
        return _skill!.ex;
    }
  }
  
  // Проверка, есть ли описание для ранга
  bool hasDescriptionForRang(SkillRang rang) {
    final desc = getDescriptionForRang(rang);
    return desc != null && desc.isNotEmpty;
  }
  
  // Получение ранга навыка в виде строки
  String getRangDisplay(SkillRang rang) {
    return rang.name;
  }

}