import 'package:flutter/material.dart';
import 'package:chaos_control/screens/purports/list/purport_list_screen.dart';
import 'package:chaos_control/screens/settings/setting_list_screen.dart';
import 'package:chaos_control/screens/barriers/bar_list_screen.dart';
import 'package:chaos_control/screens/profile/detail/profile_detail_screen.dart';

enum AppModule {
  profile,
  barriers,
  purports,
  log,
  settings,
}

List<AppModule> bottomMenuList = [
  AppModule.profile,
  AppModule.barriers,
  AppModule.purports,
];

extension AppModuleExt on AppModule {

  int get primaryIndex => isPrimaryModule ? bottomMenuList.indexOf(this) : -1;

  bool get isPrimaryModule => bottomMenuList.contains(this);

  Widget get widget {
    switch (this) {
      case AppModule.profile:
        return ProfileDetailScreen();
      case AppModule.barriers:
        return BarrierListScreen();
      case AppModule.purports:
        return PurportListScreen();
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
      case AppModule.barriers:
        return 'Преграды';
      case AppModule.purports:
        return 'Смыслы';
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
      case AppModule.barriers:
        return Icons.fort;
      case AppModule.purports:
        return Icons.local_fire_department;
      case AppModule.log:
        return Icons.timelapse;
      case AppModule.settings:
        return Icons.settings;
    }
  }
}
