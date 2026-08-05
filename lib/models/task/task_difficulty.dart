// enums.dart
import 'package:flutter/material.dart';

enum TaskDifficulty {
  easy,
  medium,
  hard,
  hell,
  fuck,
  unreal
}

// Расширяем enum дополнительными данными через extension
extension TaskDifficultyExt on TaskDifficulty {
  String get displayName {
    switch (this) {
      case TaskDifficulty.easy:
        return 'Изи';
      case TaskDifficulty.medium:
        return 'Нормально';
      case TaskDifficulty.hard:
        return 'Потно';
      case TaskDifficulty.hell:
        return 'Жёстко';
      case TaskDifficulty.fuck:
        return 'Пздц';
      case TaskDifficulty.unreal:
        return 'Нереально';
    }
  }

  Color get color {
    switch (this) {
      case TaskDifficulty.unreal:
        return const Color.fromARGB(255, 243, 33, 159);
      case TaskDifficulty.fuck:
        return const Color.fromARGB(255, 255, 64, 0);
      case TaskDifficulty.hell:
        return const Color.fromARGB(255, 255, 157, 0);
      case TaskDifficulty.hard:
        return const Color.fromARGB(255, 255, 251, 0);
      case TaskDifficulty.medium:
        return const Color.fromARGB(255, 166, 255, 0);
      case TaskDifficulty.easy:
        return const Color.fromARGB(255, 4, 255, 0);
    }
  }
}

// Получаем список всех значений для выпадающего списка
List<TaskDifficulty> allTaskDifficulties = TaskDifficulty.values;