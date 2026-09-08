import 'package:flutter/material.dart';

enum TaskStatus { done, plan }

extension TaskStatusExt on TaskStatus {
  String get displayName {
    switch (this) {
      case TaskStatus.done:
        return 'Сделал';
      case TaskStatus.plan:
        return 'В плане';
    }
  }

  Color get color {
    switch (this) {
      case TaskStatus.done:
        return Colors.green;
      case TaskStatus.plan:
        return Colors.blue;
    }
  }

  IconData get icon {
    switch (this) {
      case TaskStatus.done:
        return Icons.done;
      case TaskStatus.plan:
        return Icons.calendar_month;
    }
  }
}