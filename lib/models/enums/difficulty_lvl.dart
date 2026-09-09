import 'package:flutter/material.dart';

enum DifficultyLvl {
  F,
  E,
  D,
  C,
  B,
  A,
}

extension DifficultyLvlExt on DifficultyLvl {
  String get displayName {
    switch (this) {
      case DifficultyLvl.A:
        return 'Десятилетие';
      case DifficultyLvl.B:
        return 'Год';
      case DifficultyLvl.C:
        return 'Сезон';
      case DifficultyLvl.D:
        return 'Месяц';
      case DifficultyLvl.E:
        return 'Неделя';
      case DifficultyLvl.F:
        return 'День';
    }
  }

  int get value {
    switch (this) {
      case DifficultyLvl.A:
        return 400000;
      case DifficultyLvl.B:
        return 40000;
      case DifficultyLvl.C:
        return 10000;
      case DifficultyLvl.D:
        return 5000;
      case DifficultyLvl.E:
        return 1000;
      case DifficultyLvl.F:
        return 100;
    }
  }

  Color get color {
    switch (this) {
      case DifficultyLvl.A:
        return Colors.purpleAccent;
      case DifficultyLvl.B:
        return Colors.redAccent;
      case DifficultyLvl.C:
        return Colors.lightBlueAccent;
      case DifficultyLvl.D:
        return Colors.greenAccent;
      case DifficultyLvl.E:
        return Colors.yellow;
      case DifficultyLvl.F:
        return Colors.white;
    }
  }
}
