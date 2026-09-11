import 'package:chaos_control/models/enums/characteristics.dart';
import 'package:flutter/material.dart';

enum CharacteristicExt {
  all,
  control,
  perseverance,
  courage,
  durability,
  creativity,
}

extension ActivityTypeExt on CharacteristicExt {
  Characteristic? get characteristic {
    switch (this) {
      case CharacteristicExt.control:
        return Characteristic.control;
      case CharacteristicExt.perseverance:
        return Characteristic.perseverance;
      case CharacteristicExt.courage:
        return Characteristic.courage;
      case CharacteristicExt.durability:
        return Characteristic.durability;
      case CharacteristicExt.creativity:
        return Characteristic.creativity;
      default:
        return null;
    }
  }

  IconData get icon {
    return characteristic?.icon ?? Icons.bar_chart;
  }
}