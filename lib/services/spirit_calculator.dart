
import 'package:chaos_control/models/enums/characteristics.dart';
import 'package:chaos_control/models/profile.dart';
import 'package:chaos_control/services/analytics/analytics_repository.dart';
import 'package:chaos_control/services/notifications/implementations/n_char_points.dart';
import 'package:chaos_control/services/notifications/implementations/n_new_level.dart';
import 'package:chaos_control/services/notifications/notification_service.dart';

class SpiritCalculator {
  static int sf_1 = 1000;

  static List<double> koefs = [1.1, 1.03,  1.002];

  // Уровень
  static int getLevel(int sf) => _calc(sf).$1;
  // Требование для следующего уровня
  static int getLevelRequirements(int sf) => _calc(sf).$3;
  // Свободный опыт
  static int getLevelRemains(int sf) => _calc(sf).$2;
  
  // Очки хар-к
  static int getCharPoints(int char) => (char.toDouble() / 1000).toInt();
  // Требование для следующего уровня
  static int getCharPointsRequirements(int char) => 1000;
  // Свободный опыт
  static int getCharPointsRemains(int char) => char % 1000;
  // Очки в опыт
  static int getSFFromCP(int cp) => cp * 1000;
  

  static (int, int, int) _calc(int sf) {
    int sum = 0;
    int req = sf_1;
    int level = 1;
    while (sum + req <= sf) {
      level++;
      sum += req;
      req = (req * koefs[level ~/ 100]).toInt();
    }
    // уровень, свободный опыт, требование
    return (level, sf - sum, req);
  }

  // Проверить получение уровня и очков характеристик
  static Future checkNotifications(Map<Characteristic,int> oldChars, Map<Characteristic,int> newChars) async {
    final ns = NotificationService();
    _checkLevel(ns, oldChars.values.reduce((a, b) => a + b), newChars.values.reduce((a, b) => a + b));
    _recalcUserCharPoints(ns, oldChars, newChars);
  }

  static void _checkLevel(NotificationService ns, int oldSF, int newSF) {
    final newLevel = getLevel(newSF);
    final oldLevel = getLevel(oldSF);
    
    if (oldLevel < newLevel) {
      for (var lvl = oldLevel + 1; lvl <= newLevel; lvl++) {
        ns.showNotification(NNewLevel()..level = lvl);
      }
    }
  }

  static void _recalcUserCharPoints(NotificationService ns, Map<Characteristic,int> oldChars, Map<Characteristic,int> newChars) {
    for(var ch in Characteristic.values) {
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

  static Future recalcUserChars() async {
    final analRepo = AnalyticsRepository();
    final userRepo = ProfileRepository();

    final dto = await analRepo.getChars();
    final user = (await userRepo.get()) ?? Profile();
    
    user.control =  getSFFromCP(user.controlBase) + (dto?.control ?? 0);
    user.diligence =  getSFFromCP(user.diligenceBase) + (dto?.diligence ?? 0);
    user.strategy =  getSFFromCP(user.strategyBase) + (dto?.strategy ?? 0);
    user.durability =  getSFFromCP(user.durabilityBase) + (dto?.durability ?? 0);
    user.creativity =  getSFFromCP(user.creativityBase) + (dto?.creativity ?? 0);

    userRepo.update(user);
  }
}