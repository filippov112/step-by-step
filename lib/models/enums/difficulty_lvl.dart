import 'package:flutter/material.dart';

enum DifficultyLvl {
  F,
  E,
  D,
  C,
  B,
  A,
  S
}

extension DifficultyLvlExt on DifficultyLvl {
  String get displayName {
    switch (this) {
      case DifficultyLvl.S:
        return 'Десятилетие';
      case DifficultyLvl.A:
        return 'Год';
      case DifficultyLvl.B:
        return 'Сезон';
      case DifficultyLvl.C:
        return 'Месяц';
      case DifficultyLvl.D:
        return 'Неделя';
      case DifficultyLvl.E:
        return 'День';
      case DifficultyLvl.F:
        return 'Час';
    }
  }

  int get value {
    switch (this) {
      case DifficultyLvl.S:
        return 400000;
      case DifficultyLvl.A:
        return 40000;
      case DifficultyLvl.B:
        return 10000;
      case DifficultyLvl.C:
        return 5000;
      case DifficultyLvl.D:
        return 1000;
      case DifficultyLvl.E:
        return 100;
      case DifficultyLvl.F:
        return 5;
    }
  }

  Color get color {
    switch (this) {
      case DifficultyLvl.S:
        return Colors.purpleAccent;
      case DifficultyLvl.A:
        return Colors.redAccent;
      case DifficultyLvl.B:
        return Colors.orangeAccent;
      case DifficultyLvl.C:
        return Colors.yellowAccent;
      case DifficultyLvl.D:
        return Colors.lightBlueAccent;
      case DifficultyLvl.E:
        return Colors.greenAccent;
      case DifficultyLvl.F:
        return Colors.white;
    }
  }
}
