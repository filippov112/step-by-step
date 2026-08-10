import 'package:flutter/material.dart';

// Уровни редкости достижений
enum AchievRar {
  common,
  unusual,
  rare,
  epic,
  legendary,
  unique
}

extension AchievRarExt on AchievRar {
  String get displayName {
    switch (this) {
      case AchievRar.common:
        return 'Обычное';
      case AchievRar.unusual:
        return 'Необычное';
      case AchievRar.rare:
        return 'Редкое';
      case AchievRar.epic:
        return 'Эпическое';
      case AchievRar.legendary:
        return 'Легендарное';
      case AchievRar.unique:
        return 'Уникальное';
    }
  }

  Color get color {
    switch (this) {
      case AchievRar.common:
        return Colors.grey;
      case AchievRar.unusual:
        return Colors.green;
      case AchievRar.rare:
        return Colors.blue;
      case AchievRar.epic:
        return Colors.purple;
      case AchievRar.legendary:
        return Colors.orange;
      case AchievRar.unique:
        return Colors.red;
    }
  }
}

List<AchievRar> allAchievRar = AchievRar.values;