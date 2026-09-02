import 'package:flutter/material.dart';
import 'package:chaos_control/screens/landmarks/list/achievement_list_screen.dart';
import 'package:chaos_control/screens/projects/list/project_list_screen.dart';
import 'package:chaos_control/screens/settings/setting_list_screen.dart';
import 'package:chaos_control/screens/walls/list/wall_list_screen.dart';
import 'package:chaos_control/screens/profile/detail/profile_detail_screen.dart';

enum AppModule {
  profile,
  walls,
  landmarks,
  projects,
  log,
  settings,
}

List<AppModule> bottomMenuList = [
  AppModule.profile,
  AppModule.walls,
  AppModule.projects,
  AppModule.landmarks,
];

extension AppModuleExt on AppModule {

  int get primaryIndex => isPrimaryModule ? bottomMenuList.indexOf(this) : -1;

  bool get isPrimaryModule => bottomMenuList.contains(this);

  Widget get widget {
    switch (this) {
      case AppModule.profile:
        return ProfileDetailScreen();
      case AppModule.walls:
        return WallListScreen();
      case AppModule.landmarks:
        return AchievementListScreen();
      case AppModule.projects:
        return ProjectListScreen();
      case AppModule.settings:
        return SettingListScreen();

      case AppModule.log:
        return SettingListScreen();
    }
  }

  String get nameModule {
    switch (this) {
      case AppModule.profile:
        return 'Профиль';
      case AppModule.walls:
        return 'Стены';
      case AppModule.landmarks:
        return 'Смыслы';
      case AppModule.projects:
        return 'Проекты';
      case AppModule.log:
        return 'Логи';
      case AppModule.settings:
        return 'Настройки';
    }
  }

  IconData get icon {
    switch (this) {
      case AppModule.profile:
        return Icons.portrait;
      case AppModule.walls:
        return Icons.fort;
      case AppModule.landmarks:
        return Icons.diamond;
      case AppModule.projects:
        return Icons.work;
      case AppModule.log:
        return Icons.timelapse;
      case AppModule.settings:
        return Icons.settings;
    }
  }
}

List<AppModule> allAppModules = AppModule.values;
