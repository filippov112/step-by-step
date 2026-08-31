import 'package:flutter/material.dart';
import 'package:chaos_control/screens/achievements/list/achievement_list_screen.dart';
import 'package:chaos_control/screens/classes/list/class_list_screen.dart';
import 'package:chaos_control/screens/settings/setting_list_screen.dart';
import 'package:chaos_control/screens/skills/list/skill_list_screen.dart';
import 'package:chaos_control/screens/tags/tag_list_screen.dart';
import 'package:chaos_control/screens/tasks/list/task_list_screen.dart';
import 'package:chaos_control/screens/profile/detail/profile_detail_screen.dart';

enum AppModule {
  profile,
  tasks,
  skills,
  achievements,
  classes,
  scripts,
  templates,
  resources,
  tags,
  log,
  rewards,
  settings,
}

List<AppModule> bottomMenuList = [
  AppModule.profile,
  AppModule.tasks,
  AppModule.skills,
  AppModule.achievements,
];

extension AppModuleExt on AppModule {

  int get primaryIndex => isPrimaryModule ? bottomMenuList.indexOf(this) : -1;

  bool get isPrimaryModule => bottomMenuList.contains(this);

  Widget get widget {
    switch (this) {
      case AppModule.profile:
        return ProfileDetailScreen();
      case AppModule.tasks:
        return TaskListScreen();
      case AppModule.skills:
        return SkillListScreen();
      case AppModule.achievements:
        return AchievementListScreen();
      case AppModule.classes:
        return ClassListScreen();
      case AppModule.tags:
        return TagListScreen();
      case AppModule.settings:
        return SettingListScreen();

      case AppModule.scripts:
        return TagListScreen();
      case AppModule.templates:
        return TagListScreen();
      case AppModule.resources:
        return TagListScreen();
      case AppModule.log:
        return TagListScreen();
      case AppModule.rewards:
        return TagListScreen();
    }
  }

  String get nameModule {
    switch (this) {
      case AppModule.profile:
        return 'Профиль';
      case AppModule.tasks:
        return 'Задачи';
      case AppModule.skills:
        return 'Навыки';
      case AppModule.achievements:
        return 'Достижения';
      case AppModule.classes:
        return 'Классы';
      case AppModule.scripts:
        return 'Скрипты';
      case AppModule.templates:
        return 'Шаблоны';
      case AppModule.resources:
        return 'Ресурсы';
      case AppModule.tags:
        return 'Теги';
      case AppModule.log:
        return 'Логи';
      case AppModule.rewards:
        return 'Награды';
      case AppModule.settings:
        return 'Настройки';
    }
  }

  IconData get icon {
    switch (this) {
      case AppModule.profile:
        return Icons.portrait;
      case AppModule.tasks:
        return Icons.task_alt;
      case AppModule.skills:
        return Icons.star_border;
      case AppModule.achievements:
        return Icons.diamond;
      case AppModule.classes:
        return Icons.school_outlined;
      case AppModule.scripts:
        return Icons.repeat;
      case AppModule.templates:
        return Icons.copy;
      case AppModule.resources:
        return Icons.monetization_on;
      case AppModule.tags:
        return Icons.tag;
      case AppModule.log:
        return Icons.timelapse;
      case AppModule.rewards:
        return Icons.add;
      case AppModule.settings:
        return Icons.settings;
    }
  }
}

List<AppModule> allAppModules = AppModule.values;
