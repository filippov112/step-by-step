// Статус стены

import 'package:flutter/material.dart';

enum TargetStatus { breaking, retreated, destroyed}

extension TargetStatusExt on TargetStatus {
  String get displayName {
    switch (this) {
      case TargetStatus.breaking:
        return 'В процессе';
      case TargetStatus.retreated:
        return 'Устояла';
      case TargetStatus.destroyed:
        return 'Разрушена';
    }
  }

  Color get color {
    switch (this) {
      case TargetStatus.breaking:
        return Colors.blue;
      case TargetStatus.retreated:
        return Colors.red;
      case TargetStatus.destroyed:
        return Colors.greenAccent;
    }
  }

  IconData get icon {
    switch (this) {
      case TargetStatus.breaking:
        return Icons.loop;
      case TargetStatus.retreated:
        return Icons.dangerous;
      case TargetStatus.destroyed:
        return Icons.verified_user;
    }
  }
}