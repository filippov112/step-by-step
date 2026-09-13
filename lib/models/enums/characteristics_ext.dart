import 'package:chaos_control/models/enums/characteristics.dart';
import 'package:flutter/material.dart';

enum CharacteristicExt {
  all,
  happiness,
  diligence,
  strategy,
  durability,
  potencial,
}

extension ActivityTypeExt on CharacteristicExt {
  Characteristic? get characteristic {
    switch (this) {
      case CharacteristicExt.happiness:
        return Characteristic.happiness;
      case CharacteristicExt.diligence:
        return Characteristic.diligence;
      case CharacteristicExt.strategy:
        return Characteristic.strategy;
      case CharacteristicExt.durability:
        return Characteristic.durability;
      case CharacteristicExt.potencial:
        return Characteristic.potencial;
      default:
        return null;
    }
  }

  IconData get icon {
    return characteristic?.icon ?? Icons.bar_chart;
  }
}