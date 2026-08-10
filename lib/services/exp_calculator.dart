import 'dart:math';

class ExpCalculator {
  static int level_1 = 100;

  static List<double> koefs = [1.1, 1.03,  1.002];

  static int calcNextLevelExp(int level) {
    if (level < 1) return level_1;
    int index = -1;
    int balance = level;
    int memory = level_1;
    int batch;
    do {
      batch = balance > 100 ? 100 : balance;
      index = index < koefs.length - 1 ? index + 1 : index;
      memory = (memory * pow(koefs[index], batch - 1)).toInt();
      balance -= batch;
    } while (balance > 0);
    return memory;
  }
}