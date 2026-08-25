import 'package:flutter/material.dart';
import 'package:chaos_control/models/other/image.dart';
import 'package:chaos_control/models/skill.dart';
import 'package:chaos_control/models/enums/skill_rang.dart';
import 'package:chaos_control/models/skill_condition.dart';
import 'package:chaos_control/models/tag.dart';
import 'package:chaos_control/models/tag_skill.dart';

class SkillFormModel extends ChangeNotifier {
  final _skillRepo = SkillRepository();
  final _conditionRepo = SkillConditionRepository();
  final _tagRepo = TagRepository();
  final _tagSkillRepo = TagSkillRepository();

  // Редактируемый навык
  Skill? _skill;

  // Поля формы
  String _title = '';
  SkillRang _rang = SkillRang.F;
  CustomImageData? _icon;
  String? _f;
  String? _e;
  String? _d;
  String? _c;
  String? _b;
  String? _a;
  String? _s;
  String? _ss;
  String? _sss;
  String? _ex;

  // Условия
  List<SkillCondition> selectedConditions = [];
  
  // Теги
  List<Tag> _selectedTags = [];

  bool _isLoading = false;
  bool _isSaving = false;
  String? _error;

  // Геттеры
  String get title => _title;
  SkillRang get rang => _rang;
  CustomImageData? get icon => _icon;
  List<Tag> get selectedTags => _selectedTags;
  bool get isLoading => _isLoading;
  bool get isSaving => _isSaving;
  String? get error => _error;
  bool isEditing = false;

  // Инициализация для редактирования
  Future<void> loadData(Skill? skill) async {
    try {
      isEditing = skill != null;
      _skill = skill ?? Skill.create(title: '');
      _title = _skill!.title;
      _rang = _skill!.rang;
      _icon = _skill!.icon;
      _f = _skill!.f;
      _e = _skill!.e;
      _d = _skill!.d;
      _c = _skill!.c;
      _b = _skill!.b;
      _a = _skill!.a;
      _s = _skill!.s;
      _ss = _skill!.ss;
      _sss = _skill!.sss;
      _ex = _skill!.ex;
      _isLoading = true;
      notifyListeners();

      // Загружаем условия
      final allConditions = await _conditionRepo.getAll();
      final selectedCond = allConditions
          .where((c) => c.skillId == _skill!.id)
          .toList();
      selectedCond.sort((a, b) => a.rang.index.compareTo(b.rang.index));
      selectedConditions = selectedCond;
      notifyListeners();

      // Загружаем выбранные теги для навыка
      final allTagSkills = await _tagSkillRepo.getAll();

      _selectedTags.clear();
      final _ = allTagSkills.where((ts) => ts.skillId == _skill!.id).map((
        ts,
      ) async {
        final tag = await _tagRepo.get(ts.tagId);
        if (tag != null) {
          _selectedTags.add(tag);
        }
        return ts.tagId;
      });
    } catch (e) {
      _error = 'Ошибка загрузки данных: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Обновление полей
  void setTitle(String? value) {
    _title = value ?? '';
    notifyListeners();
  }

  void setRang(SkillRang value) {
    _rang = value;
    notifyListeners();
  }

  void setDescription(SkillRang rang, String value) {
    switch (rang) {
      case SkillRang.F:
        _f = value.isEmpty ? null : value;
        break;
      case SkillRang.E:
        _e = value.isEmpty ? null : value;
        break;
      case SkillRang.D:
        _d = value.isEmpty ? null : value;
        break;
      case SkillRang.C:
        _c = value.isEmpty ? null : value;
        break;
      case SkillRang.B:
        _b = value.isEmpty ? null : value;
        break;
      case SkillRang.A:
        _a = value.isEmpty ? null : value;
        break;
      case SkillRang.S:
        _s = value.isEmpty ? null : value;
        break;
      case SkillRang.SS:
        _ss = value.isEmpty ? null : value;
        break;
      case SkillRang.SSS:
        _sss = value.isEmpty ? null : value;
        break;
      case SkillRang.EX:
        _ex = value.isEmpty ? null : value;
        break;
    }
    notifyListeners();
  }

  String? getDescriptionForRang(SkillRang rang) {
    switch (rang) {
      case SkillRang.F:
        return _f;
      case SkillRang.E:
        return _e;
      case SkillRang.D:
        return _d;
      case SkillRang.C:
        return _c;
      case SkillRang.B:
        return _b;
      case SkillRang.A:
        return _a;
      case SkillRang.S:
        return _s;
      case SkillRang.SS:
        return _ss;
      case SkillRang.SSS:
        return _sss;
      case SkillRang.EX:
        return _ex;
    }
  }

  // Сохранение навыка
  Future<bool> saveSkill() async {
    if (_title.trim().isEmpty) {
      _error = 'Введите название навыка';
      notifyListeners();
      return false;
    }

    _isSaving = true;
    _error = null;
    notifyListeners();

    try {
      Skill skill;

      if (isEditing) {
        // Обновляем существующий навык
        skill = Skill(
          id: _skill!.id,
          title: _title.trim(),
          rang: _rang,
          time: _skill!.time,
          experience: _skill!.experience,
          icon: _icon,
          f: _f,
          e: _e,
          d: _d,
          c: _c,
          b: _b,
          a: _a,
          s: _s,
          ss: _ss,
          sss: _sss,
          ex: _ex,
        );
        await _skillRepo.update(skill);

        // Обновляем условия (удаляем старые и добавляем новые)
        final oldConditions = await _conditionRepo.getAll();
        final skillOldConditions = oldConditions.where(
          (c) => c.skillId == skill.id,
        );
        for (var condition in skillOldConditions) {
          await _conditionRepo.delete(condition.id);
        }

        for (var condition in selectedConditions) {
          final newCondition = SkillCondition.create(
            rang: condition.rang,
            skillId: skill.id,
            description: condition.description,
            date: condition.date,
          );
          await _conditionRepo.insert(newCondition);
        }

        // Обновляем теги
        final oldTagSkills = await _tagSkillRepo.getAll();
        final skillOldTagSkills = oldTagSkills.where(
          (ts) => ts.skillId == skill.id,
        );
        for (var ts in skillOldTagSkills) {
          await _tagSkillRepo.delete(ts.skillId, ts.tagId);
        }

        for (var tag in _selectedTags) {
          final tagSkill = TagSkill.create(skillId: skill.id, tagId: tag.id);
          await _tagSkillRepo.insert(tagSkill);
        }
      } else {
        // Создаём новый навык
        skill = Skill.create(
          title: _title.trim(),
          rang: _rang,
          time: 0,
          experience: 0,
          icon: _icon,
          f: _f,
          e: _e,
          d: _d,
          c: _c,
          b: _b,
          a: _a,
          s: _s,
          ss: _ss,
          sss: _sss,
          ex: _ex,
        );
        await _skillRepo.insert(skill);

        // Сохраняем условия
        for (var condition in selectedConditions) {
          final newCondition = SkillCondition.create(
            rang: condition.rang,
            skillId: skill.id,
            description: condition.description,
            date: condition.date,
          );
          await _conditionRepo.insert(newCondition);
        }

        // Сохраняем теги
        for (var tag in _selectedTags) {
          final tagSkill = TagSkill.create(skillId: skill.id, tagId: tag.id);
          await _tagSkillRepo.insert(tagSkill);
        }
      }

      _isSaving = false;
      notifyListeners();
      return true;
    } catch (e) {
      _error = 'Ошибка сохранения навыка: $e';
      _isSaving = false;
      notifyListeners();
      return false;
    }
  }

  void setIcon(CustomImageData? value) {
    _icon = value;
    notifyListeners();
  }

  void setSelectedTags(List<Tag> tags) {
    _selectedTags = tags;
    notifyListeners();
  }

  void addCondition(SkillCondition condition) {
    final conds = selectedConditions.toList();
    conds.add(condition);
    conds.sort((a, b) => a.rang.index.compareTo(b.rang.index));
    selectedConditions = conds;
    notifyListeners();
  }

  void updateCondition(int index, SkillCondition condition) {
    final conds = selectedConditions.toList();
    conds[index] = condition;
    conds.sort((a, b) => a.rang.index.compareTo(b.rang.index));
    selectedConditions = conds;
    notifyListeners();
  }

  void removeCondition(int index) {
    final conds = selectedConditions.toList();
    conds.removeAt(index);
    selectedConditions = conds;
    notifyListeners();
  }
}
