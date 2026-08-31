import 'package:flutter/material.dart';
import 'package:chaos_control/models/achievement.dart';
import 'package:chaos_control/models/enums/achiev_rar.dart';
import 'package:chaos_control/models/other/image.dart';


class AchievementFormModel extends ChangeNotifier {

  // -------------- Fields ----------------
  Achievement achievement = Achievement.create(title: '');
  final achiRepo = AchievementRepository();

  List<Achievement> allAchievements = [];

  String selectedTitle = '';
  String selectedDescription = '';
  CustomImageData? selectedIcon;
  DateTime? selectedDate;
  AchievRar selectedRarity = AchievRar.common;

  bool isEditing = false;

  // ---------------- Initialization ------------------

  void setAchievement(Achievement? achi) {
    isEditing = achi != null;
    achievement = achi ?? Achievement.create(title: '');
    selectedDate = achievement.date;
    selectedRarity = achievement.rarity;
    selectedIcon = achievement.icon;
    selectedTitle = achievement.title;
    selectedDescription = achievement.description;
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
  void setDate(DateTime? date) {
    selectedDate = date;
    notifyListeners();
  }
  void setRarity(AchievRar rarity) {
    selectedRarity = rarity;
    notifyListeners();
  }


  // ---------- CRUD ---------------------

  Future deleteAchievement() async {
    if (isEditing) {
      try {
        await achiRepo.delete(achievement.id);
      } catch (e) {
        // print(e);
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
    }
    catch (e) {
      // print(e);
      return false;
    }
    return true;
  }

}