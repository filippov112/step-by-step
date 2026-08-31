import 'package:flutter/material.dart';

// Сложность стены
enum WallDiff {
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

extension WallDiffExt on WallDiff {
  Color get color {
    switch (this) {
      case WallDiff.F:
        return Colors.grey;
      case WallDiff.E:
        return Colors.blueGrey;
      case WallDiff.D:
        return Colors.blue;
      case WallDiff.C:
        return Colors.green;
      case WallDiff.B:
        return Colors.lime;
      case WallDiff.A:
        return Colors.orange;
      case WallDiff.S:
        return Colors.red;
      case WallDiff.SS:
        return Colors.purple;
      case WallDiff.SSS:
        return Colors.deepPurple;
      case WallDiff.EX:
        return Colors.amber;
    }
  }
}
