import 'package:chaos_control/screens/home/widgets/bottom_menu.dart';
import 'package:chaos_control/screens/home/widgets/left_menu.dart';
import 'package:chaos_control/screens/settings/categories/calc_constants.dart';
import 'package:chaos_control/screens/settings/setting_list_model.dart';
import 'package:chaos_control/screens/settings/widgets/scaffold.dart';
import 'package:chaos_control/screens/settings/widgets/tile.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SettingListScreen extends StatelessWidget {
  const SettingListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final model = context.read<SettingListModel>();
    final calcConstantsCat = SettingsTile(title: 'Константы расчетов', widgetCallback: () => const SettingsCalcConstants());

    return SettingsScaffold(
      title: 'Настройки', 
      drawer: const MainMenuDrawer(),
      bottomBar: const MainBottomMenu(),
      cancelCallback: model.cancel,
      children: [calcConstantsCat, ],
    );
  }
}