import 'package:chaos_control/models/enums/characteristics.dart';
import 'package:chaos_control/models/profile.dart';
import 'package:chaos_control/services/analytics/analytics_repository.dart';
import 'package:chaos_control/services/notifications/implementations/n_char_points.dart';
import 'package:chaos_control/services/notifications/implementations/n_new_level.dart';
import 'package:chaos_control/services/notifications/notification_service.dart';
import 'package:chaos_control/services/settings/settings_service.dart';
import 'package:flutter/material.dart';

class SpiritCalculator extends ChangeNotifier {
  final SettingsService _service;
  SpiritCalculator(this._service);

  // Уровень
  int getLevel(int sf) => _calc(sf).$1;
  // Требование для следующего уровня
  int getLevelRequirements(int sf) => _calc(sf).$3;
  // Свободный опыт
  int getLevelRemains(int sf) => _calc(sf).$2;

  // Очки хар-к
  int getCharPoints(int char) => (char.toDouble() / _service.calcCharPointReq).toInt();
  // Требование для следующего уровня
  int getCharPointsRequirements(int char) => _service.calcCharPointReq;
  // Свободный опыт
  int getCharPointsRemains(int char) => char % _service.calcCharPointReq;
  // Очки в опыт
  int getSFFromCP(int cp) => cp * _service.calcCharPointReq;

  (int, int, int) _calc(int sf) {
    int sum = 0;
    int req = _service.calcReq1;
    double koef = _service.calcKoef;
    int level = 1;
    while (sum + req <= sf) {
      level++;
      sum += req;
      req = (req * koef).toInt();
    }
    // уровень, свободный опыт, требование
    return (level, sf - sum, req);
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

  void _checkLevel(NotificationService ns, int oldSF, int newSF) async {
    final newLevel = getLevel(newSF);
    final oldLevel = getLevel(oldSF);
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
    final user = (await userRepo.get()) ?? Profile();

    user.happiness = getSFFromCP(user.happinessBase) + (dto?.happiness ?? 0);
    user.diligence = getSFFromCP(user.diligenceBase) + (dto?.diligence ?? 0);
    user.intellection =
        getSFFromCP(user.intellectionBase) + (dto?.intellection ?? 0);
    user.durability = getSFFromCP(user.durabilityBase) + (dto?.durability ?? 0);
    user.potencial = getSFFromCP(user.potencialBase) + (dto?.potencial ?? 0);

    userRepo.update(user);
  }
}
