// enums.dart
import 'package:flutter/material.dart';

enum TaskStatus {
  work,
  done,
  closed,
  paused,
  wait
}

// Расширяем enum дополнительными данными через extension
extension TaskStatusExt on TaskStatus {
  String get displayName {
    switch (this) {
      case TaskStatus.work:
        return 'В работе';
      case TaskStatus.done:
        return 'Выполнено';
      case TaskStatus.closed:
        return 'Закрыто';
      case TaskStatus.paused:
        return 'На паузе';
      case TaskStatus.wait:
        return 'Ожидает';
    }
  }

  IconData get icon {
    switch (this) {
      case TaskStatus.work:
        return Icons.play_circle;
      case TaskStatus.done:
        return Icons.check_circle;
      case TaskStatus.closed:
        return Icons.cancel;
      case TaskStatus.paused:
        return Icons.pause_circle;
      case TaskStatus.wait:
        return Icons.hourglass_empty;
    }
  }

  Color get color {
    switch (this) {
      case TaskStatus.work:
        return const Color.fromARGB(255, 148, 0, 217);
      case TaskStatus.done:
        return const Color.fromARGB(255, 0, 222, 0);
      case TaskStatus.closed:
        return const Color.fromARGB(255, 219, 0, 0);
      case TaskStatus.paused:
        return const Color.fromARGB(255, 215, 204, 1);
      case TaskStatus.wait:
        return const Color.fromARGB(234, 0, 188, 225);
    }
  }
}

// Получаем список всех значений для выпадающего списка
List<TaskStatus> allTaskStatuses = TaskStatus.values;