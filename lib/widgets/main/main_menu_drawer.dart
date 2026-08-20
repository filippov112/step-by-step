import 'package:flutter/material.dart';
import 'package:life_game/screens/classes/list/class_list_screen.dart';
import 'package:life_game/screens/settings/setting_list_screen.dart';
import 'package:life_game/screens/tags/tag_list_screen.dart';

enum AppModule {
  classes,
  scripts,
  templates,
  resources,
  archive,
  actions,
  tags,
  log,
  rewards,
  settings,
}

// Боковое меню для главных экранов модулей приложения
class MainMenuDrawer extends StatelessWidget {
  final AppModule? currentModule;
  
  const MainMenuDrawer({
    super.key,
    this.currentModule,
  });

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
                MenuItemTile(
                  icon: Icons.school_outlined,
                  title: 'Классы',
                  module: AppModule.classes,
                  widget: classes,
                  currentRoute: currentModule,
                ),
                MenuItemTile(
                  icon: Icons.code,
                  title: 'Скрипты',
                  module: AppModule.scripts,
                  widget: tags,
                  currentRoute: currentModule,
                ),
                MenuItemTile(
                  icon: Icons.copy,
                  title: 'Шаблоны',
                  module: AppModule.templates,
                  widget: tags,
                  currentRoute: currentModule,
                ),
                MenuItemTile(
                  icon: Icons.monetization_on,
                  title: 'Ресурсы',
                  module: AppModule.resources,
                  widget: tags,
                  currentRoute: currentModule,
                ),
                MenuItemTile(
                  icon: Icons.archive,
                  title: 'Архив',
                  module: AppModule.archive,
                  widget: tags,
                  currentRoute: currentModule,
                ),
                MenuItemTile(
                  icon: Icons.repeat,
                  title: 'Действия',
                  module: AppModule.actions,
                  widget: tags,
                  currentRoute: currentModule,
                ),
                MenuItemTile(
                  icon: Icons.tag,
                  title: 'Теги',
                  module: AppModule.tags,
                  widget: tags,
                  currentRoute: currentModule,
                ),
                MenuItemTile(
                  icon: Icons.timelapse,
                  title: 'Журнал',
                  module: AppModule.log,
                  widget: tags,
                  currentRoute: currentModule,
                ),
                MenuItemTile(
                  icon: Icons.add,
                  title: 'Награды',
                  module: AppModule.rewards,
                  widget: tags,
                  currentRoute: currentModule,
                ),
                MenuItemTile(
                  icon: Icons.settings,
                  title: 'Настройки',
                  module: AppModule.settings,
                  widget: settings,
                  currentRoute: currentModule,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}


class MenuItemTile extends StatelessWidget {

  final IconData icon;
  final String title;
  final AppModule module;
  final Widget widget;
  final AppModule? currentRoute;

  const MenuItemTile({super.key, 
    required this.icon,
    required this.title,
    required this.module,
    required this.widget,
    required this.currentRoute,
  });
  
  @override
  Widget build(BuildContext context) {
    final isSelected = currentRoute == module;
  
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
        if (currentRoute != module) {
          Navigator.push(context, MaterialPageRoute(builder: (_) => widget));
        }
      },
    );
  }
}