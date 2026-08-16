import 'package:flutter/material.dart';
import 'package:life_game/screens/classes/class_list_screen.dart';
import 'package:life_game/screens/settings/setting_list_screen.dart';
import 'package:life_game/screens/tags/tag_list_screen.dart';
import 'package:life_game/themes/solo_leveling_theme.dart';

// Боковое меню для главных экранов модулей приложения
class MainMenuDrawer extends StatelessWidget {
  final String? currentRoute;
  
  const MainMenuDrawer({
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
      tileColor: isSelected ? Theme.of(context).focusColor : Theme.of(context).cardColor,
      leading: Icon(
        icon,
      ),
      title: Text(
        title,
        style: TextStyle(
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
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
    late Widget classes = ClassListScreen();
    late Widget tags = TagListScreen();
    late Widget settings = SettingListScreen();

    return Drawer(
      child: Column(
        children: [
          // Список пунктов меню
          Expanded(
            child: ListView(
              children: [
                _buildMenuItem(
                  context: context,
                  icon: Icons.school_outlined,
                  title: 'Классы',
                  route: '/classes',
                  widget: tags,
                  currentRoute: currentRoute ?? '',
                ),
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