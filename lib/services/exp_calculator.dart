
import 'package:chaos_control/models/class.dart';
import 'package:chaos_control/models/profile.dart';

class SpiritCalculator {
  static int level_1 = 100;
  static int time_1 = 100;

  static List<double> koefs = [1.1, 1.03,  1.002];

  // Уровень
  static int getLevel(int exptime) => _calc(exptime).$1;

  // Требование для следующего уровня
  static int getRequirements(int exptime) => _calc(exptime).$3;

  // Свободный опыт
  static int getRemains(int exptime) => _calc(exptime).$2;

  static (int, int, int) _calc(int exptime) {
    int sum = 0;
    int req = time_1;
    int level = 1;
    while (sum + req <= exptime) {
      level++;
      sum += req;
      req = (req * koefs[level ~/ 100]).toInt();
    }
    // уровень, свободный опыт, требование
    return (level, exptime - sum, req);
  }


  static void recalcLevelClass(Class cls) {
    
  }

  static void recalcLevelUser(Profile user) {
    
  }
}