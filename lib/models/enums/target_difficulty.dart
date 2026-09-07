import 'package:flutter/material.dart';

// Сложность стены
enum TargetDiff {
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

extension TargetDiffExt on TargetDiff {
  Color get color {
    switch (this) {
      case TargetDiff.F:
        return Colors.grey;
      case TargetDiff.E:
        return Colors.blueGrey;
      case TargetDiff.D:
        return Colors.blue;
      case TargetDiff.C:
        return Colors.green;
      case TargetDiff.B:
        return Colors.lime;
      case TargetDiff.A:
        return Colors.orange;
      case TargetDiff.S:
        return Colors.red;
      case TargetDiff.SS:
        return Colors.purple;
      case TargetDiff.SSS:
        return Colors.deepPurple;
      case TargetDiff.EX:
        return Colors.amber;
    }
  }
}
