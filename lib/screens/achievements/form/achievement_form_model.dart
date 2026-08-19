import 'package:flutter/material.dart';
import 'package:life_game/models/achievement.dart';
import 'package:life_game/models/enums/achiev_rar.dart';
import 'package:life_game/models/tag.dart';
import 'package:life_game/models/tag_achievement.dart';


class AchievementFormModel extends ChangeNotifier {

  // -------------- Fields ----------------
  late Achievement achievement;
  final tagAchiRepo = TagAchievementRepository();
  final achiRepo = AchievementRepository();
  final tagRepo = TagRepository();
  

  List<TagAchievement> _tagAchievements = [];
  List<Achievement> allAchievements = [];

  late String selectedTitle;
  late String selectedDescription;
  String? selectedIcon;
  DateTime? selectedDate;
  late AchievRar selectedRarity;

  List<Tag> selectedTags = [];

  late bool isEditing;

  // ---------------- Initialization ------------------

  void setAchievement(Achievement? achi) {
    isEditing = achi != null;
    achievement = achi ?? Achievement.create(title: '');
    selectedDate = achievement.date;
    selectedRarity = achievement.rarity;
    selectedIcon = achievement.icon;
    selectedTitle = achievement.title;
    selectedDescription = achievement.description;
    loadData();
  }

  Future loadData() async {
    await _loadTaskTags();
    notifyListeners();
  }

  Future _loadTaskTags() async {
    _tagAchievements = (await tagAchiRepo.getAll()).where((tt) => tt.achievementId == achievement.id).toList();
    final tags = <Tag>[];

    for (final tagAch in _tagAchievements) {
      final tag = await tagRepo.get(tagAch.tagId);
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
  void setDate(DateTime? date) {
    selectedDate = date;
    notifyListeners();
  }
  void setRarity(AchievRar rarity) {
    selectedRarity = rarity;
    notifyListeners();
  }
  void setSelectedTags(List<Tag> tags) {
    selectedTags = tags;
    notifyListeners();
  }

  // ---------- CRUD ---------------------

  Future deleteAchievement() async {
    if (isEditing) {
      try {
        await achiRepo.delete(achievement.id);
      } catch (e) {
        print(e);
      }
    }
  }

  Future<bool> saveAchievement() async {
    achievement.title = selectedTitle;
    achievement.description = selectedDescription;
    achievement.date = selectedDate;
    achievement.icon = selectedIcon;
    achievement.rarity = selectedRarity;
    try {
      if (isEditing) {
        await achiRepo.update(achievement);
      } else {
        await achiRepo.insert(achievement);
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
    final existingTagIds = _tagAchievements.map((tt) => tt.tagId).toSet();
    final newTagIds = selectedTags.map((tag) => tag.id).toSet();
    final tagsToRemove = existingTagIds.difference(newTagIds);
    final tagsToAdd = newTagIds.difference(existingTagIds);

    for (final tagId in tagsToRemove) {
      await tagAchiRepo.delete(achievement.id, tagId);
    }
    for (final tagId in tagsToAdd) {
      final tagAchievement = TagAchievement.create(
        achievementId: achievement.id,
        tagId: tagId,
      );
      await tagAchiRepo.insert(tagAchievement);
    }
  }

  
}