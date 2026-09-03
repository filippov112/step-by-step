// Статус стены
import 'dart:ui';

import 'package:flutter/material.dart';

enum WallStatus { breaking, retreated, destroyed}

extension WallStatusExt on WallStatus {
  String get displayName {
    switch (this) {
      case WallStatus.breaking:
        return 'В процессе';
      case WallStatus.retreated:
        return 'Устояла';
      case WallStatus.destroyed:
        return 'Разрушена';
    }
  }

  Color get color {
    switch (this) {
      case WallStatus.breaking:
        return Colors.blue;
      case WallStatus.retreated:
        return Colors.red;
      case WallStatus.destroyed:
        return Colors.greenAccent;
    }
  }

  IconData get icon {
    switch (this) {
      case WallStatus.breaking:
        return Icons.loop;
      case WallStatus.retreated:
        return Icons.dangerous;
      case WallStatus.destroyed:
        return Icons.verified_user;
    }
  }
}