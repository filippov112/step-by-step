import 'package:flutter/material.dart';

// Типы смыслов
enum PurportType {
  wealth,
  creation,
  consumption,
}

extension PurportRarExt on PurportType {
  String get displayName {
    switch (this) {
      case PurportType.wealth:
        return 'Ценности';
      case PurportType.creation:
        return 'Созидание';
      case PurportType.consumption:
        return 'Потребление';
    }
  }

  Color get color {
    switch (this) {
      case PurportType.wealth:
        return Colors.redAccent;
      case PurportType.creation:
        return Colors.green;
      case PurportType.consumption:
        return Colors.purpleAccent;
    }
  }
}