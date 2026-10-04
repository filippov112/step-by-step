import 'package:step_by_step/models/enums/characteristics.dart';
import 'package:flutter/material.dart';

enum CharacteristicExt {
  all,
  knowledge,
  skills,
  abilities,
  creativity,
  languages,
  health
}

extension ActivityTypeExt on CharacteristicExt {
  Characteristic? get characteristic {
    switch (this) {
      case CharacteristicExt.knowledge:
        return Characteristic.knowledge;
      case CharacteristicExt.skills:
        return Characteristic.skills;
      case CharacteristicExt.abilities:
        return Characteristic.abilities;
      case CharacteristicExt.creativity:
        return Characteristic.creativity;
      case CharacteristicExt.languages:
        return Characteristic.languages;
      case CharacteristicExt.health:
        return Characteristic.health;
      default:
        return null;
    }
  }

  IconData get icon {
    return characteristic?.icon ?? Icons.bar_chart;
  }
}