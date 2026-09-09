import 'package:flutter/material.dart';

enum Characteristic {
  control,
  perseverance,
  courage,
  durability,
  creativity
}

extension CharacteristicsExt on Characteristic {

  String get displayName {
    switch (this) {
      case Characteristic.control:
        return 'Контроль';
      case Characteristic.perseverance:
        return 'Упорство';
        case Characteristic.courage:
        return 'Смелость';
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
      case Characteristic.perseverance:
        return Colors.orangeAccent;
      case Characteristic.courage:
        return Colors.redAccent;
      case Characteristic.durability:
        return Colors.lightBlueAccent;
      case Characteristic.creativity:
        return Colors.purpleAccent;
    }
  }

  IconData get icon {
    switch (this) {
      case Characteristic.control:
        return Icons.self_improvement;
      case Characteristic.perseverance:
        return Icons.construction;
      case Characteristic.courage:
        return Icons.favorite;
      case Characteristic.durability:
        return Icons.diamond;
      case Characteristic.creativity:
        return Icons.visibility;
    }
  }

  String get emoji {
    switch (this) {
      case Characteristic.control:
        return '☯';
      case Characteristic.perseverance:
        return '🔥';
      case Characteristic.courage:
        return '⚔️';
      case Characteristic.durability:
        return '🛡️';
      case Characteristic.creativity:
        return '🧠';
    }
  }
}