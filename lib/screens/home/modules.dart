import 'package:flutter/material.dart';
import 'package:chaos_control/screens/purports/list/purport_list_screen.dart';
import 'package:chaos_control/screens/settings/setting_list_screen.dart';
import 'package:chaos_control/screens/records/record_list_screen.dart';
import 'package:chaos_control/screens/profile/detail/profile_detail_screen.dart';

enum AppModule {
  profile,
  chronicle,
  purports,
  settings,
}

List<AppModule> bottomMenuList = [
  AppModule.profile,
  AppModule.chronicle,
  AppModule.purports,
];

extension AppModuleExt on AppModule {

  int get primaryIndex => isPrimaryModule ? bottomMenuList.indexOf(this) : -1;

  bool get isPrimaryModule => bottomMenuList.contains(this);

  Widget get widget {
    switch (this) {
      case AppModule.profile:
        return ProfileDetailScreen();
      case AppModule.chronicle:
        return RecordListScreen();
      case AppModule.purports:
        return PurportListScreen();
      case AppModule.settings:
        return SettingListScreen();
    }
  }

  String get nameModule {
    switch (this) {
      case AppModule.profile:
        return 'Игрок';
      case AppModule.chronicle:
        return 'Хроники';
      case AppModule.purports:
        return 'Смыслы';
      case AppModule.settings:
        return 'Настройки';
    }
  }

  IconData get icon {
    switch (this) {
      case AppModule.profile:
        return Icons.person;
      case AppModule.chronicle:
        return Icons.auto_stories;
      case AppModule.purports:
        return Icons.local_fire_department;
      case AppModule.settings:
        return Icons.settings;
    }
  }
}
