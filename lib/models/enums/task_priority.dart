// enums.dart
import 'dart:ui';

import 'package:flutter/material.dart';

enum TaskPriority {
  low,
  medium,
  high,
  top,
}

// Расширяем enum дополнительными данными через extension
extension TaskPriorityExt on TaskPriority {
  String get displayName {
    switch (this) {
      case TaskPriority.low:
        return 'Низкий';
      case TaskPriority.medium:
        return 'Средний';
      case TaskPriority.high:
        return 'Высокий';
      case TaskPriority.top:
        return 'Высший';
    }
  }

  Color get color {
    switch (this) {
      case TaskPriority.low:
        return const Color.fromARGB(255, 0, 200, 3);
      case TaskPriority.medium:
        return const Color.fromARGB(255, 189, 186, 1);
      case TaskPriority.high:
        return const Color.fromARGB(255, 188, 91, 0);
      case TaskPriority.top:
        return const Color.fromARGB(255, 189, 0, 0);
    }
  }
}

// Получаем список всех значений для выпадающего списка
List<TaskPriority> allTaskPriorities = TaskPriority.values;