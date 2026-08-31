import 'dart:ui';
import 'package:flutter/material.dart';

// Приоритеты
enum WallPriority {
  low,
  medium,
  high,
  top,
}

// Расширяем enum дополнительными данными через extension
extension WallPriorityExt on WallPriority {
  String get displayName {
    switch (this) {
      case WallPriority.low:
        return 'Низкий';
      case WallPriority.medium:
        return 'Средний';
      case WallPriority.high:
        return 'Высокий';
      case WallPriority.top:
        return 'Высший';
    }
  }

  Color get color {
    switch (this) {
      case WallPriority.low:
        return const Color.fromARGB(255, 0, 200, 3);
      case WallPriority.medium:
        return const Color.fromARGB(255, 189, 186, 1);
      case WallPriority.high:
        return const Color.fromARGB(255, 188, 91, 0);
      case WallPriority.top:
        return const Color.fromARGB(255, 189, 0, 0);
    }
  }
}