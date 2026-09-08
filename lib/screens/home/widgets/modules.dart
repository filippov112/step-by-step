import 'package:flutter/material.dart';
import 'package:chaos_control/screens/purports/list/purport_list_screen.dart';
import 'package:chaos_control/screens/projects/list/project_list_screen.dart';
import 'package:chaos_control/screens/settings/setting_list_screen.dart';
import 'package:chaos_control/screens/targets/list/target_list_screen.dart';
import 'package:chaos_control/screens/profile/detail/profile_detail_screen.dart';

enum AppModule {
  profile,
  targets,
  purports,
  projects,
  log,
  settings,
}

List<AppModule> bottomMenuList = [
  AppModule.profile,
  AppModule.targets,
  AppModule.projects,
  AppModule.purports,
];

extension AppModuleExt on AppModule {

  int get primaryIndex => isPrimaryModule ? bottomMenuList.indexOf(this) : -1;

  bool get isPrimaryModule => bottomMenuList.contains(this);

  Widget get widget {
    switch (this) {
      case AppModule.profile:
        return ProfileDetailScreen();
      case AppModule.targets:
        return TargetListScreen();
      case AppModule.purports:
        return PurportListScreen();
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
      case AppModule.targets:
        return 'Цели';
      case AppModule.purports:
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
      case AppModule.targets:
        return Icons.center_focus_strong;
      case AppModule.purports:
        return Icons.local_fire_department;
      case AppModule.projects:
        return Icons.workspaces;
      case AppModule.log:
        return Icons.timelapse;
      case AppModule.settings:
        return Icons.settings;
    }
  }
}

List<AppModule> allAppModules = AppModule.values;
