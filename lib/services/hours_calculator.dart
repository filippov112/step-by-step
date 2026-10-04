import 'dart:math';

import 'package:step_by_step/models/enums/characteristics.dart';
import 'package:step_by_step/models/profile.dart';
import 'package:step_by_step/services/analytics/analytics_repository.dart';
import 'package:step_by_step/services/notifications/implementations/n_char_points.dart';
import 'package:step_by_step/services/notifications/implementations/n_new_level.dart';
import 'package:step_by_step/services/notifications/notification_service.dart';
import 'package:step_by_step/services/settings/settings_service.dart';
import 'package:flutter/material.dart';

class HoursCalculator extends ChangeNotifier {
  final SettingsService _service;
  HoursCalculator(this._service);

  // Уровень
  int getLevel(int hours) => _calc(hours).$1;
  // Требование для следующего уровня
  int getLevelRequirements(int hours) => _calc(hours).$3;
  // Свободный опыт
  int getLevelRemains(int hours) => _calc(hours).$2;

  // Очки хар-к
  int getCharPoints(int char) => (char.toDouble() / _service.calcCharPointReq).toInt();
  // Требование для следующего уровня
  int getCharPointsRequirements(int char) => _service.calcCharPointReq;
  // Свободный опыт
  int getCharPointsRemains(int char) => char % _service.calcCharPointReq;
  // Очки в опыт
  int getHoursFromCP(int cp) => cp * _service.calcCharPointReq;

  (int, int, int) _calc(int hours) {
    int sum = 0;
    int req = _service.calcReq1;
    int currentReq = req;
    double koef = max(1, _service.calcKoef);
    int level = 1;
    while (sum + currentReq <= hours) {
      level++;
      sum += currentReq;
      currentReq = (req * pow(koef, level-1)).round() ;
    }
    // уровень, свободный опыт, требование
    return (level, hours - sum, currentReq);
  }

  // Проверить получение уровня и очков характеристик
  void checkNotifications(
    Map<Characteristic, int> oldChars,
    Map<Characteristic, int> newChars,
  ) {
    final ns = NotificationService();
    _checkLevel(
      ns,
      oldChars.values.reduce((a, b) => a + b),
      newChars.values.reduce((a, b) => a + b),
    );
    _recalcUserCharPoints(ns, oldChars, newChars);
  }

  void _checkLevel(NotificationService ns, int oldHours, int newHours) async {
    final newLevel = getLevel(newHours);
    final oldLevel = getLevel(oldHours);
    if (oldLevel < newLevel) {
      for (var lvl = oldLevel + 1; lvl <= newLevel; lvl++) {
        ns.showNotification(NNewLevel()..level = lvl);
      }
    }
  }

  void _recalcUserCharPoints(
    NotificationService ns,
    Map<Characteristic, int> oldChars,
    Map<Characteristic, int> newChars,
  ) {
    for (var ch in Characteristic.values) {
      final newPoints = getCharPoints(newChars[ch] ?? 0);
      final oldPoints = getCharPoints(oldChars[ch] ?? 0);

      if (oldPoints < newPoints) {
        final n = NCharPoints();
        n.char = ch;
        n.value = newPoints - oldPoints;
        ns.showNotification(n);
      }
    }
  }

  Future recalcUserChars() async {
    final analRepo = AnalyticsRepository();
    final userRepo = ProfileRepository();

    final dto = await analRepo.getChars();
    final user = (await userRepo.get()) ?? Profile(chars: CharValues(), baseChars: CharValues());

    final dtoMap = dto?.chars.map;
    final userBaseCharsMap = user.baseChars.map;
    final userCharsMap = CharValues().map;
    for (var charType in Characteristic.values) {
      userCharsMap[charType] = getHoursFromCP(userBaseCharsMap[charType] ?? 0) + (dtoMap?[charType] ?? 0);
    }
    user.chars.setChars(userCharsMap);
    userRepo.update(user);
  }
}
