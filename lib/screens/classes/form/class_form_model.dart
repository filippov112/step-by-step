import 'package:flutter/material.dart';
import 'package:life_game/models/class.dart';
import 'package:life_game/models/class_skill.dart';
import 'package:life_game/models/other/image.dart';
import 'package:life_game/models/skill.dart';
import 'package:life_game/models/tag.dart';
import 'package:life_game/models/tag_class.dart';


class ClassFormModel extends ChangeNotifier {

  // -------------- Fields ----------------
  Class record = Class.create(title: '');
  final _tagClassRepo = TagClassRepository();
  final _classRepo = ClassRepository();
  final _tagRepo = TagRepository();
  final _classSkillRepo = ClassSkillRepository();
  final _skillRepo = SkillRepository();
  
  List<Skill> allSkills = [];
  List<TagClass> _classTags = [];
  List<Class> records = [];
  List<ClassSkill> selectedClassSkills = [];

  String selectedTitle = '';
  String selectedDescription = '';
  CustomImageData? selectedIcon;
  List<Tag> selectedTags = [];
  List<ClassSkill> _classSkills = [];

  bool isEditing = false;

  // ---------------- Initialization ------------------

  void setClass(Class? cls) {
    isEditing = cls != null;
    record = cls ?? Class.create(title: '');
    selectedIcon = record.icon;
    selectedTitle = record.title;
    selectedDescription = record.description;
    notifyListeners();
    _loadTaskTags();
    _loadSkills();
    _loadRewards();
  }


  Future _loadTaskTags() async {
    _classTags = (await _tagClassRepo.getAll()).where((tt) => tt.classId == record.id).toList();
    final tags = <Tag>[];

    for (final tagAch in _classTags) {
      final tag = await _tagRepo.get(tagAch.tagId);
      if (tag != null) {
        tags.add(tag);
      }
    }
    selectedTags = tags;
    notifyListeners();
  }

  Future _loadSkills() async {
    allSkills = await _skillRepo.getAll();
    notifyListeners();
  }

  Future _loadRewards() async {
    _classSkills = (await _classSkillRepo.getAll()).where((tt) => tt.classId == record.id).toList();
    selectedClassSkills = _classSkills.toList();
    notifyListeners();
  }

  // -------------------- Commands ------------------------

  void setTitle(String? title) {
    selectedTitle = title ?? '';
    notifyListeners();
  }
  void setDescription(String? description) {
    selectedDescription = description ?? '';
    notifyListeners();
  }
  void setIcon(CustomImageData? value) {
    selectedIcon = value;
    notifyListeners();
  }
  void setSelectedTags(List<Tag> tags) {
    selectedTags = tags;
    notifyListeners();
  }
  void setSelectedClassSkills(List<ClassSkill> skills) {
    selectedClassSkills = skills;
    notifyListeners();
  }

  // ---------- CRUD ---------------------

  Future delete() async {
    if (isEditing) {
      try {
        await _classRepo.delete(record.id);
      } catch (e) {
        print(e);
      }
    }
  }

  Future<bool> save() async {
    record.title = selectedTitle;
    record.description = selectedDescription;
    record.icon = selectedIcon;
    try {
      if (isEditing) {
        await _classRepo.update(record);
      } else {
        await _classRepo.insert(record);
      }
      await _saveTags();
      await _saveSkills();
    }
    catch (e) {
      print(e);
      return false;
    }
    return true;
  }

  Future _saveTags() async {
    final existingTagIds = _classTags.map((tt) => tt.tagId).toSet();
    final newTagIds = selectedTags.map((tag) => tag.id).toSet();
    final tagsToRemove = existingTagIds.difference(newTagIds);
    final tagsToAdd = newTagIds.difference(existingTagIds);

    for (final tagId in tagsToRemove) {
      await _tagClassRepo.delete(record.id, tagId);
    }
    for (final tagId in tagsToAdd) {
      final tagClass = TagClass.create(
        classId: record.id,
        tagId: tagId,
      );
      await _tagClassRepo.insert(tagClass);
    }
  }

  Future _saveSkills() async {
    final existeds = _classSkills.map((r) => r.skillId).toSet();
    final currents = selectedClassSkills.map((r) => r.skillId).toSet();
    final toRemove = existeds.difference(currents);
    final toAdd = currents.difference(existeds);

    for (final skillId in toRemove) {
      await _classSkillRepo.delete(skillId, record.id);
    }
    for (final skillId in toAdd) {
      var reward = selectedClassSkills.firstWhere((r) => r.skillId == skillId);
      await _classSkillRepo.insert(reward);
    }
  }
}