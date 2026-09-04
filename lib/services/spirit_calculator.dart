
import 'package:chaos_control/models/profile.dart';
import 'package:chaos_control/services/notifications/implementations/n_new_level.dart';
import 'package:chaos_control/services/notifications/notification_service.dart';

class SpiritCalculator {
  static int level_1 = 100;
  static int efforts_1 = 100;

  static List<double> koefs = [1.1, 1.03,  1.002];

  // Уровень
  static int getLevel(int efforts) => _calc(efforts).$1;

  // Требование для следующего уровня
  static int getRequirements(int efforts) => _calc(efforts).$3;

  // Свободный опыт
  static int getRemains(int efforts) => _calc(efforts).$2;

  static (int, int, int) _calc(int efforts) {
    int sum = 0;
    int req = efforts_1;
    int level = 1;
    while (sum + req <= efforts) {
      level++;
      sum += req;
      req = (req * koefs[level ~/ 100]).toInt();
    }
    // уровень, свободный опыт, требование
    return (level, efforts - sum, req);
  }

  static Future recalcLevelUser(Profile user) async {
    final newLevel = getLevel(user.efforts);
    if (newLevel > user.level) {
      user.level = newLevel;
      final repo = ProfileRepository();
      await repo.update(user);
      final ns = NotificationService();
      ns.showNotification(NNewLevel()..level = newLevel);
    }
  }
}