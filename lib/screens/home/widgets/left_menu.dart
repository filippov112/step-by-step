import 'package:flutter/material.dart';
import 'package:chaos_control/screens/home/home_model.dart';
import 'package:chaos_control/screens/home/widgets/modules.dart';
import 'package:provider/provider.dart';

// Боковое меню для главных экранов модулей приложения
class MainMenuDrawer extends StatelessWidget {
  const MainMenuDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    var currentModule = context.select<HomeModel, AppModule>(
      (model) => model.currentModule,
    );

    return Drawer(
      child: Column(
        children: [
          // Список пунктов меню
          Expanded(
            child: ListView(
              children: allAppModules
                  .map(
                    (module) => MenuItemTile(
                      icon: module.icon,
                      title: module.nameModule,
                      module: module,
                      widget: module.widget,
                      currentRoute: currentModule,
                    ),
                  )
                  .toList(),
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

  const MenuItemTile({
    super.key,
    required this.icon,
    required this.title,
    required this.module,
    required this.widget,
    required this.currentRoute,
  });

  @override
  Widget build(BuildContext context) {
    final isSelected = currentRoute == module;
    final selectModule = context.read<HomeModel>().selectModule;

    return ListTile(
      tileColor: isSelected
          ? Theme.of(context).focusColor
          : Theme.of(context).cardColor,
      leading: Icon(icon),
      title: Text(
        title,
        style: TextStyle(
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
        ),
      ),
      onTap: () {
        Navigator.pop(context); // Закрываем меню
        if (currentRoute != module) {
          selectModule(module);
        }
      },
    );
  }
}
