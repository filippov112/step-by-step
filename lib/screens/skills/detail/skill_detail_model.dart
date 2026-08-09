import 'package:flutter/material.dart';
import 'package:life_game/models/enums/skill_rang.dart';
import 'package:life_game/models/skill.dart';
import 'package:life_game/models/skill_condition.dart';


class SkillDetailModel extends ChangeNotifier {
  final SkillRepository _skillRepo = SkillRepository();
  final SkillConditionRepository _conditionRepo = SkillConditionRepository();
  
  Skill? _skill;
  List<SkillCondition> _conditions = [];
  bool _isLoading = false;
  String? _error;
  
  Skill? get skill => _skill;
  List<SkillCondition> get conditions => _conditions;
  bool get isLoading => _isLoading;
  String? get error => _error;
  
  // Загрузка данных навыка
  Future<void> loadSkill(String skillId) async {
    _isLoading = true;
    _error = null;
    _skill = null;
    _conditions = [];
    notifyListeners();
    
    try {
      _skill = await _skillRepo.get(skillId);
      if (_skill != null) {
        // Загружаем условия для этого навыка
        final allConditions = await _conditionRepo.getAll();
        _conditions = allConditions.where((c) => c.skillId == skillId).toList();
        _conditions.sort((a, b) => a.rang.index.compareTo(b.rang.index));
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
  
  // Прогресс до следующего ранга
  double getProgressToNextRang() {
    if (_skill == null) return 0.0;
    
    final currentRangIndex = _skill!.rang.index;
    if (currentRangIndex >= SkillRang.values.length - 1) return 1.0;
    
    // Простое вычисление прогресса на основе уровня
    // Можно усложнить в зависимости от механики игры
    const maxLevel = 100;
    return (_skill!.level / maxLevel).clamp(0.0, 1.0);
  }
  
  // Следующий ранг
  SkillRang? getNextRang() {
    if (_skill == null) return null;
    final currentIndex = _skill!.rang.index;
    if (currentIndex < SkillRang.values.length - 1) {
      return SkillRang.values[currentIndex + 1];
    }
    return null;
  }
}