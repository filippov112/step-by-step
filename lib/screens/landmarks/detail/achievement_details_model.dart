import 'package:flutter/material.dart';
import 'package:chaos_control/models/achievement.dart';

class AchievementDetailsModel extends ChangeNotifier {
  final AchievementRepository _achiRepo = AchievementRepository();

  Achievement achievement = Achievement.create(title: '');

  Future<bool> checkExist() async {
    var newRecord = await _achiRepo.get(achievement.id);
    if (newRecord != null) {
      await setAchievement(newRecord);
      return true;
    }
    return false;
  }


  Future setAchievement(Achievement achi) async {
    achievement = achi;
    notifyListeners();
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