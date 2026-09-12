import 'package:flutter/material.dart';

enum Characteristic {
  control,
  diligence,
  strategy,
  durability,
  creativity
}

extension CharacteristicsExt on Characteristic {

  String get displayName {
    switch (this) {
      case Characteristic.control:
        return 'Контроль';
      case Characteristic.diligence:
        return 'Усердие';
        case Characteristic.strategy:
        return 'Стратегия';
      case Characteristic.durability:
        return 'Стойкость';
      case Characteristic.creativity:
        return 'Креативность';
    }
  }

  Color get color {
    switch (this) {
      case Characteristic.control:
        return Colors.greenAccent;
      case Characteristic.diligence:
        return Colors.yellow;
      case Characteristic.strategy:
        return Colors.redAccent;
      case Characteristic.durability:
        return Colors.white;
      case Characteristic.creativity:
        return Colors.purpleAccent;
    }
  }

  IconData get icon {
    switch (this) {
      case Characteristic.control:
        return Icons.self_improvement;
      case Characteristic.diligence:
        return Icons.construction;
      case Characteristic.strategy:
        return Icons.account_tree;
      case Characteristic.durability:
        return Icons.diamond;
      case Characteristic.creativity:
        return Icons.visibility;
    }
  }

  String get emoji {
    switch (this) {
      case Characteristic.control:
        return '🎯';
      case Characteristic.diligence:
        return '💪';
      case Characteristic.strategy:
        return '🧠';
      case Characteristic.durability:
        return '🛡️';
      case Characteristic.creativity:
        return '✨';
    }
  }
}