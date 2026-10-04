import 'dart:convert';

import 'package:flutter/material.dart';

enum Characteristic {
  knowledge,
  skills,
  abilities,
  creativity,
  languages,
  health
}

// Хранилище значений характеристик
class CharValues {
  static const cP1 = "_c1";
  static const cP2 = "_c2";
  static const cP3 = "_c3";
  static const cP4 = "_c4";
  static const cP5 = "_c5";
  static const cP6 = "_c6";

  int p1 = 0;
  int p2 = 0;
  int p3 = 0;
  int p4 = 0;
  int p5 = 0;
  int p6 = 0;

  int get hours => p1 + p2 + p3 + p4 + p5 + p6;

  Map<Characteristic,int> get map => <Characteristic,int>{
    Characteristic.knowledge: p1,
    Characteristic.skills: p2,
    Characteristic.abilities: p3,
    Characteristic.creativity: p4,
    Characteristic.languages: p5,
    Characteristic.health: p6
  };

  void setChars(Map<Characteristic, int> newUserChars) {
    p1 = newUserChars[Characteristic.knowledge] ?? 0;
    p2 = newUserChars[Characteristic.skills] ?? 0;
    p3 = newUserChars[Characteristic.abilities] ?? 0;
    p4 = newUserChars[Characteristic.creativity] ?? 0;
    p5 = newUserChars[Characteristic.languages] ?? 0;
    p6 = newUserChars[Characteristic.health] ?? 0;
  }

  Map<String, Object?> toMap() {
    var map = <String, Object?>{
      cP1: p1,
      cP2: p2,
      cP3: p3,
      cP4: p4,
      cP5: p5,
      cP6: p6,
    };
    return map;
  }
  CharValues.fromMap(Map map) {
    p1 = map[cP1];
    p2 = map[cP2];
    p3 = map[cP3];
    p4 = map[cP4];
    p5 = map[cP5];
    p6 = map[cP6];
  }

  String toJson() => jsonEncode(toMap());
  factory CharValues.fromJson(String json) => CharValues.fromMap(jsonDecode(json));

  CharValues({List<int>? values}) {
    p1 = values?[0] ?? 0;
    p2 = values?[1] ?? 0;
    p3 = values?[2] ?? 0;
    p4 = values?[3] ?? 0;
    p5 = values?[4] ?? 0;
    p6 = values?[5] ?? 0;
  }
}

extension CharacteristicsExt on Characteristic {

  String get displayName {
    switch (this) {
      case Characteristic.knowledge:
        return 'Знания';
      case Characteristic.skills:
        return 'Умения';
      case Characteristic.abilities:
        return 'Способности';
      case Characteristic.creativity:
        return 'Креативность';
      case Characteristic.languages:
        return 'Языки';
      case Characteristic.health:
        return 'Здоровье';
    }
  }

  Color get color {
    switch (this) {
      case Characteristic.knowledge:
        return Colors.yellow;
      case Characteristic.skills:
        return Colors.red;
      case Characteristic.abilities:
        return Colors.orange;
      case Characteristic.creativity:
        return const Color.fromARGB(255, 249, 97, 239);
      case Characteristic.languages:
        return Colors.white;
      case Characteristic.health:
        return Colors.greenAccent;
    }
  }

  IconData get icon {
    switch (this) {
      case Characteristic.knowledge:
        return Icons.school;
      case Characteristic.skills:
        return Icons.construction;
      case Characteristic.abilities:
        return Icons.back_hand;
      case Characteristic.creativity:
        return Icons.lightbulb;
      case Characteristic.languages:
        return Icons.translate;
      case Characteristic.health:
        return Icons.local_hospital;
    }
  }

  String get abr {
    switch (this) {
      case Characteristic.knowledge:
        return 'KNW';
      case Characteristic.skills:
        return 'SKL';
      case Characteristic.abilities:
        return 'ABL';
      case Characteristic.creativity:
        return 'CRT';
      case Characteristic.languages:
        return 'LAN';
      case Characteristic.health:
        return 'HLT';
    }
  }
}