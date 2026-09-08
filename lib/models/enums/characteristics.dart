import 'package:flutter/material.dart';

enum Characteristics {
  control,
  perseverance,
  courage,
  durability,
  creativity
}

extension CharacteristicsExt on Characteristics {

  String get displayName {
    switch (this) {
      case Characteristics.control:
        return 'Контроль';
      case Characteristics.perseverance:
        return 'Упорство';
        case Characteristics.courage:
        return 'Смелость';
      case Characteristics.durability:
        return 'Стойкость';
      case Characteristics.creativity:
        return 'Креативность';
    }
  }

  Color get color {
    switch (this) {
      case Characteristics.control:
        return Colors.greenAccent;
      case Characteristics.perseverance:
        return Colors.orangeAccent;
      case Characteristics.courage:
        return Colors.redAccent;
      case Characteristics.durability:
        return Colors.lightBlueAccent;
      case Characteristics.creativity:
        return Colors.purpleAccent;
    }
  }

  IconData get icon {
    switch (this) {
      case Characteristics.control:
        return Icons.self_improvement;
      case Characteristics.perseverance:
        return Icons.construction;
      case Characteristics.courage:
        return Icons.favorite;
      case Characteristics.durability:
        return Icons.diamond;
      case Characteristics.creativity:
        return Icons.visibility;
    }
  }

  String get emoji {
    switch (this) {
      case Characteristics.control:
        return '☯';
      case Characteristics.perseverance:
        return '🔥';
      case Characteristics.courage:
        return '⚔️';
      case Characteristics.durability:
        return '🛡️';
      case Characteristics.creativity:
        return '🧠';
    }
  }
}