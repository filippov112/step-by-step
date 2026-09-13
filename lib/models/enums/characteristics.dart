import 'package:flutter/material.dart';

enum Characteristic {
  happiness,
  diligence,
  strategy,
  durability,
  potencial
}

extension CharacteristicsExt on Characteristic {

  String get displayName {
    switch (this) {
      case Characteristic.happiness:
        return 'Счастье';
      case Characteristic.diligence:
        return 'Усердие';
        case Characteristic.strategy:
        return 'Стратегия';
      case Characteristic.durability:
        return 'Стойкость';
      case Characteristic.potencial:
        return 'Потенциал';
    }
  }

  Color get color {
    switch (this) {
      case Characteristic.happiness:
        return Colors.yellow;
      case Characteristic.diligence:
        return Colors.red;
      case Characteristic.strategy:
        return Colors.redAccent;
      case Characteristic.durability:
        return Colors.white;
      case Characteristic.potencial:
        return Colors.greenAccent;
    }
  }

  IconData get icon {
    switch (this) {
      case Characteristic.happiness:
        return Icons.light_mode;
      case Characteristic.diligence:
        return Icons.construction;
      case Characteristic.strategy:
        return Icons.account_tree;
      case Characteristic.durability:
        return Icons.diamond;
      case Characteristic.potencial:
        return Icons.local_hospital;
    }
  }

  String get abr {
    switch (this) {
      case Characteristic.happiness:
        return 'MP';
      case Characteristic.diligence:
        return 'STR';
      case Characteristic.strategy:
        return 'INT';
      case Characteristic.durability:
        return 'DEF';
      case Characteristic.potencial:
        return 'VIT';
    }
  }
}