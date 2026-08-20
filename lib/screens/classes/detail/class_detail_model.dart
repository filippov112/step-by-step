import 'package:flutter/material.dart';
import 'package:life_game/models/class.dart';
import 'package:life_game/models/class_skill.dart';
import 'package:life_game/models/skill.dart';
import 'package:life_game/models/tag.dart';
import 'package:life_game/models/tag_class.dart';

class ClassDetailModel extends ChangeNotifier {
  final _classRepo = ClassRepository();
  final _classSkillRepo = ClassSkillRepository();
  final _skillRepo = SkillRepository();
  final _tagClassRepo = TagClassRepository();
  final _tagRepo = TagRepository();

  Class record = Class.create(title: '');
  List<Tag> tags = [];
  List<Skill> skills = [];

  Future<bool> checkExist() async {
    var newRecord = await _classRepo.get(record.id);
    if (newRecord != null) {
      record = newRecord;
      notifyListeners();
      return true;
    }
    return false;
  }

  Future _loadClassSkills() async {
    skills.clear();
    List<ClassSkill> classSkills = await _classSkillRepo.getByClassId(record.id);
    for (var cs in classSkills) {
      var skl = await _skillRepo.get(cs.skillId);
      if (skl == null) continue;
      skills.add(skl);
    }
    notifyListeners();
  }

  Future<void> _loadClassTags() async {
    var tagsClass = (await _tagClassRepo.getAll()).where((tt) => tt.classId == record.id).toList();
    final tags = <Tag>[];

    for (final ta in tagsClass) {
      final tag = await _tagRepo.get(ta.tagId);
      if (tag != null) {
        tags.add(tag);
      }
    }
    this.tags = tags;
    notifyListeners();
  }

  Future setClass(Class cls) async {
    record = cls;
    notifyListeners();
    await _loadClassTags();
    await _loadClassSkills();
  }

  Future _delete(String id) async {
    await _classRepo.delete(id);
    notifyListeners();
  }

  Future deleteThis() async {
    await _delete(record.id);
  }
}