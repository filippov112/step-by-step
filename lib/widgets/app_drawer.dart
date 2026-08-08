import 'package:flutter/material.dart';
import 'package:life_game/screens/settings/setting_list_screen.dart';
import 'package:life_game/screens/tags/tag_list_screen.dart';
import 'package:life_game/themes/solo_leveling_theme.dart';

class AppDrawer extends StatelessWidget {
  final String? currentRoute;
  
  const AppDrawer({
    super.key,
    this.currentRoute,
  });

  Widget _buildMenuItem({
    required BuildContext context,
    required IconData icon,
    required String title,
    required String route,
    required Widget widget,
    String currentRoute = '',
  }) {
    final isSelected = currentRoute == route;
  
    return ListTile(
      tileColor: isSelected ? SoloLevelingTheme.steelBlue : SoloLevelingTheme.navyBlue,
      leading: Icon(
        icon,
        // color: isSelected ? Colors.blue.shade700 : Colors.grey.shade700,
      ),
      title: Text(
        title,
        style: TextStyle(
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          // color: isSelected ? Colors.blue.shade700 : Colors.black87,
        ),
      ),
      onTap: () {
        Navigator.pop(context); // Закрываем меню
        if (currentRoute != route) {
          Navigator.push(context, MaterialPageRoute(builder: (_) => widget));
        }
      },
    );
    
  }

  @override
  Widget build(BuildContext context) {
    late Widget tags = TagListScreen();
    late Widget settings = SettingListScreen();

    Widget header = UserAccountsDrawerHeader(
      accountName: const Text(''),
      accountEmail: const Text(''),
      margin:null,
      arrowColor: SoloLevelingTheme.navyBlue,
    );

    return Drawer(
      child: Column(
        children: [
          // Хедер с аватаром
          header,
          // Список пунктов меню
          Expanded(
            child: ListView(
              // padding: const EdgeInsets.symmetric(vertical: 3),
              children: [
                _buildMenuItem(
                  context: context,
                  icon: Icons.tag,
                  title: 'Теги',
                  route: '/tags',
                  widget: tags,
                  currentRoute: currentRoute ?? '',
                ),
                _buildMenuItem(
                  context: context,
                  icon: Icons.settings,
                  title: 'Настройки',
                  route: '/settings',
                  widget: settings,
                  currentRoute: currentRoute ?? '',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}