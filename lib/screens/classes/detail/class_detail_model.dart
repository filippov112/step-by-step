import 'package:flutter/material.dart';
import 'package:life_game/models/class.dart';
import 'package:life_game/models/tag.dart';
import 'package:life_game/models/tag_class.dart';

class ClassDetailModel extends ChangeNotifier {
  final _classRepo = ClassRepository();
  final _tagClassRepo = TagClassRepository();
  final _tagRepo = TagRepository();

  late Class record;
  List<Tag> tags = [];

  Future<bool> checkExist() async {
    var newRecord = await _classRepo.get(record.id);
    if (newRecord != null) {
      record = newRecord;
      notifyListeners();
      return true;
    }
    return false;
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
    await _loadClassTags();
  }

  Future _delete(String id) async {
    await _classRepo.delete(id);
    notifyListeners();
  }

  Future deleteThis() async {
    await _delete(record.id);
  }
}