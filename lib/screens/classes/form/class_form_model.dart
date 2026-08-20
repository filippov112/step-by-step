import 'package:flutter/material.dart';
import 'package:life_game/models/class.dart';
import 'package:life_game/models/tag.dart';
import 'package:life_game/models/tag_class.dart';


class ClassFormModel extends ChangeNotifier {

  // -------------- Fields ----------------
  late Class record;
  final _tagClassRepo = TagClassRepository();
  final _classRepo = ClassRepository();
  final _tagRepo = TagRepository();
  

  List<TagClass> _classTags = [];
  List<Class> records = [];

  late String selectedTitle;
  late String selectedDescription;
  String? selectedIcon;
  List<Tag> selectedTags = [];

  late bool isEditing;

  // ---------------- Initialization ------------------

  void setClass(Class? cls) {
    isEditing = cls != null;
    record = cls ?? Class.create(title: '');
    selectedIcon = record.icon;
    selectedTitle = record.title;
    selectedDescription = record.description;
    loadData();
  }

  Future loadData() async {
    await _loadTaskTags();
    notifyListeners();
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
  }

  // -------------------- Commands ------------------------

  void setTitle(String title) {
    selectedTitle = title;
    notifyListeners();
  }
  void setDescription(String description) {
    selectedDescription = description;
    notifyListeners();
  }
  void setIcon(String? iconPath) {
    selectedIcon = iconPath;
    notifyListeners();
  }
  void setSelectedTags(List<Tag> tags) {
    selectedTags = tags;
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

  
}