import 'package:flutter/material.dart';
import 'package:chaos_control/screens/home/home_model.dart';
import 'package:chaos_control/screens/home/modules.dart';
import 'package:provider/provider.dart';

// Нижняя панель меню основных вкладок приложения
class MainBottomMenu extends StatelessWidget {
  const MainBottomMenu({super.key});

  @override
  Widget build(BuildContext context) {

    final currentModule = context.select<HomeModel,AppModule>((model) => model.currentModule);
    final selectModule = context.read<HomeModel>().selectModule;

    int getIndex() {
      if (currentModule.isPrimaryModule) {
        return currentModule.primaryIndex;
      } else {
        return 0;
      }
    }

    void select(int index) {
      if (currentModule.isPrimaryModule) {
        selectModule(bottomMenuList[index]);
      } else {
        if (index == 0) return;
        selectModule(bottomMenuList[index - 1]);
      }
    }

    return BottomNavigationBar(
        onTap: select,
        currentIndex: getIndex(),
        
        items: [
          if (!currentModule.isPrimaryModule) ...{
            BottomNavigationBarItem(
              icon: Icon(currentModule.icon),
              label: currentModule.nameModule
            )
          },
          ...bottomMenuList.map((module) => BottomNavigationBarItem(
            icon: Icon(module.icon),
            label: module.nameModule
          )),
        ],
         
        
    );
  }
  
}