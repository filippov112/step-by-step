import 'package:flutter/material.dart';

enum TagType {
  skill,
  achievement,
  task,
  class_,
  common
}

extension TagTypeExt on TagType {
   String get displayName {
    switch (this) {
      case TagType.common:
        return 'Общий';
      case TagType.skill:
        return 'Навык';
      case TagType.achievement:
        return 'Достижение';
      case TagType.task:
        return 'Задача';
      case TagType.class_:
        return 'Класс';
    }
  }

  Color get color {
    switch (this) {
      case TagType.common:
        return Colors.grey;
      case TagType.skill:
        return Colors.blue;
      case TagType.achievement:
        return Colors.amber;
      case TagType.task:
        return Colors.green;
      case TagType.class_:
        return Colors.deepOrange;
    }
  }
}

List<TagType> allTagTypes = TagType.values;