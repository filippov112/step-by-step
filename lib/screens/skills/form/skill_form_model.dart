import 'package:flutter/material.dart';
import 'package:life_game/models/skill.dart';
import 'package:life_game/models/enums/skill_rang.dart';
import 'package:life_game/services/file_storage_service.dart';

class SkillFormModel extends ChangeNotifier {
  final SkillRepository _skillRepo = SkillRepository();
  final FileStorageService _fileStorage = FileStorageService();
  
  // Редактируемый навык
  Skill? _editingSkill;
  
  // Поля формы
  String _title = '';
  SkillRang _rang = SkillRang.F;
  int _level = 1;
  int _experience = 0;
  String _iconPath = '';
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
  
  bool _isLoading = false;
  String? _error;
  
  // Геттеры
  String get title => _title;
  SkillRang get rang => _rang;
  int get level => _level;
  int get experience => _experience;
  String get iconPath => _iconPath;
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get isEditing => _editingSkill != null;
  
  // Инициализация для редактирования
  void loadSkillForEditing(Skill skill) {
    _editingSkill = skill;
    _title = skill.title;
    _rang = skill.rang;
    _level = skill.level;
    _experience = skill.experience;
    _iconPath = skill.icon;
    _f = skill.f;
    _e = skill.e;
    _d = skill.d;
    _c = skill.c;
    _b = skill.b;
    _a = skill.a;
    _s = skill.s;
    _ss = skill.ss;
    _sss = skill.sss;
    _ex = skill.ex;
    notifyListeners();
  }
  
  // Обновление полей
  void setTitle(String value) {
    _title = value;
    notifyListeners();
  }
  
  void setRang(SkillRang value) {
    _rang = value;
    notifyListeners();
  }
  
  void setLevel(int value) {
    _level = value.clamp(1, 999);
    notifyListeners();
  }
  
  void setExperience(int value) {
    _experience = value.clamp(0, 999999);
    notifyListeners();
  }
  
  void setIconPath(String value) {
    _iconPath = value;
    notifyListeners();
  }
  
  void setDescription(SkillRang rang, String value) {
    switch (rang) {
      case SkillRang.F:
        _f = value;
        break;
      case SkillRang.E:
        _e = value;
        break;
      case SkillRang.D:
        _d = value;
        break;
      case SkillRang.C:
        _c = value;
        break;
      case SkillRang.B:
        _b = value;
        break;
      case SkillRang.A:
        _a = value;
        break;
      case SkillRang.S:
        _s = value;
        break;
      case SkillRang.SS:
        _ss = value;
        break;
      case SkillRang.SSS:
        _sss = value;
        break;
      case SkillRang.EX:
        _ex = value;
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
    
    _isLoading = true;
    _error = null;
    notifyListeners();
    
    try {
      Skill skill;
      
      if (isEditing) {
        // Обновляем существующий навык
        skill = Skill(
          id: _editingSkill!.id,
          title: _title.trim(),
          rang: _rang,
          level: _level,
          experience: _experience,
          icon: _iconPath,
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
      } else {
        // Создаём новый навык
        skill = Skill.create(
          title: _title.trim(),
          rang: _rang,
          level: _level,
          experience: _experience,
          icon: _iconPath,
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
      }
      
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _error = 'Ошибка сохранения навыка: $e';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }
  
  // Выбор иконки
  Future<bool> pickIcon() async {
    try {
      final file = await _fileStorage.pickImageFromGallery();
      if (file == null) return false;
      
      final savedPath = await _fileStorage.saveSkillIcon(file);
      if (savedPath != null) {
        // Удаляем старую иконку если она есть и не является стандартной
        if (_iconPath.isNotEmpty) {
          await _fileStorage.deleteOldFile(_iconPath);
        }
        _iconPath = savedPath;
        notifyListeners();
        return true;
      }
      return false;
    } catch (e) {
      _error = 'Ошибка выбора иконки: $e';
      notifyListeners();
      return false;
    }
  }
  
  // Сброс формы
  void resetForm() {
    _editingSkill = null;
    _title = '';
    _rang = SkillRang.F;
    _level = 1;
    _experience = 0;
    _iconPath = '';
    _f = null;
    _e = null;
    _d = null;
    _c = null;
    _b = null;
    _a = null;
    _s = null;
    _ss = null;
    _sss = null;
    _ex = null;
    _error = null;
    notifyListeners();
  }
}