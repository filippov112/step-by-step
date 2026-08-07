import 'dart:ui';

enum SkillRang {
  EX,
  SSS,
  SS,
  S,
  A,
  B,
  C,
  D,
  E,
  F
}

// Расширяем enum дополнительными данными через extension
extension SkillRangExt on SkillRang {
  Color get color {
    switch (this) {
      case SkillRang.EX:
        return const Color.fromARGB(255, 113, 18, 222);
      case SkillRang.SSS:
        return const Color.fromARGB(255, 205, 0, 212);
      case SkillRang.SS:
        return const Color.fromARGB(255, 199, 1, 44);
      case SkillRang.S:
        return const Color.fromARGB(255, 214, 103, 0);
      case SkillRang.A:
        return const Color.fromARGB(255, 243, 215, 33);
      case SkillRang.B:
        return const Color.fromARGB(255, 135, 243, 33);
      case SkillRang.C:
        return const Color.fromARGB(255, 0, 228, 209);
      case SkillRang.D:
        return const Color.fromARGB(255, 0, 130, 211);
      case SkillRang.E:
        return const Color.fromARGB(210, 0, 28, 212);
      case SkillRang.F:
        return const Color.fromARGB(255, 48, 48, 48);
    }
  }
}

// Получаем список всех значений для выпадающего списка
List<SkillRang> allSkillRangs = SkillRang.values;