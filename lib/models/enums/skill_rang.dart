import 'package:flutter/material.dart';

enum SkillRang {
  F,
  E,
  D,
  C,
  B,
  A,
  S,
  SS,
  SSS,
  EX
}

// Расширяем enum дополнительными данными через extension
extension SkillRangExt on SkillRang {
  Color get color {
    switch (this) {
      case SkillRang.F:
        return Colors.grey;
      case SkillRang.E:
        return Colors.blueGrey;
      case SkillRang.D:
        return Colors.blue;
      case SkillRang.C:
        return Colors.green;
      case SkillRang.B:
        return Colors.lime;
      case SkillRang.A:
        return Colors.orange;
      case SkillRang.S:
        return Colors.red;
      case SkillRang.SS:
        return Colors.purple;
      case SkillRang.SSS:
        return Colors.deepPurple;
      case SkillRang.EX:
        return Colors.amber;
    }
  }
}

// Получаем список всех значений для выпадающего списка
List<SkillRang> allSkillRangs = SkillRang.values;