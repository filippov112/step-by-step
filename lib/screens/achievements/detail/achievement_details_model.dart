import 'package:flutter/material.dart';
import 'package:life_game/models/achievement.dart';
import 'package:life_game/models/tag.dart';
import 'package:life_game/models/tag_achievement.dart';

class AchievementDetailsModel extends ChangeNotifier {
  final AchievementRepository _achiRepo = AchievementRepository();
  final tagAchiRepo = TagAchievementRepository();
  final tagRepo = TagRepository();

  late Achievement achievement;
  List<Tag> tags = [];

  Future<bool> checkExist() async {
    var newRecord = await _achiRepo.get(achievement.id);
    if (newRecord != null) {
      await setAchievement(newRecord);
      return true;
    }
    return false;
  }

  Future<void> _loadAchiTags() async {
    var tagsAchi = (await tagAchiRepo.getAll()).where((tt) => tt.achievementId == achievement.id).toList();
    final tags = <Tag>[];

    for (final ta in tagsAchi) {
      final tag = await tagRepo.get(ta.tagId);
      if (tag != null) {
        tags.add(tag);
      }
    }
    this.tags = tags;
    notifyListeners();
  }

  Future setAchievement(Achievement achi) async {
    achievement = achi;
    await _loadAchiTags();
  }

  void setDone() async {
    achievement.date = achievement.date ?? DateTime.now();
    await _update(achievement);
    notifyListeners();
  }

  Future _delete(String id) async {
    await _achiRepo.delete(id);
    notifyListeners();
  }

  Future deleteThis() async {
    await _delete(achievement.id);
  }

  Future _update(Achievement achi) async {
    await _achiRepo.update(achi);
    notifyListeners();
  }
}