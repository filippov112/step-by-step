
import 'package:chaos_control/models/profile.dart';
import 'package:chaos_control/services/notifications/implementations/n_new_level.dart';
import 'package:chaos_control/services/notifications/notification_service.dart';

class SpiritCalculator {
  static int level_1 = 100;
  static int sf_1 = 100;

  static List<double> koefs = [1.1, 1.03,  1.002];

  // Уровень
  static int getLevel(int sf) => _calc(sf).$1;

  // Требование для следующего уровня
  static int getRequirements(int sf) => _calc(sf).$3;

  // Свободный опыт
  static int getRemains(int sf) => _calc(sf).$2;

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

  static Future recalcLevelUser(Profile user) async {
    final newLevel = getLevel(user.spiritFragments);
    if (newLevel > user.level) {
      final ns = NotificationService();
      for (var lvl = user.level + 1; lvl <= newLevel; lvl++) {
        ns.showNotification(NNewLevel()..level = lvl);
      }
    }
    if (newLevel != user.level) {
      user.level = newLevel;
      final repo = ProfileRepository();
      await repo.update(user);
    }
  }
}