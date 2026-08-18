import 'package:flutter/material.dart';
import 'package:life_game/screens/home/home_model.dart';
import 'package:provider/provider.dart';

// Нижняя панель меню основных вкладок приложения
class MainBottomMenu extends StatelessWidget {
  const MainBottomMenu({super.key});

  @override
  Widget build(BuildContext context) {
    
    int currentTabId = context.select<HomeModel,int>((model) => model.currentTab);

    return BottomNavigationBar(
        onTap: context.read<HomeModel>().selectTab,
        currentIndex: currentTabId,
        
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.portrait_outlined),
            activeIcon: Icon(Icons.portrait),
            label: 'Профиль',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.task_alt_outlined),
            activeIcon: Icon(Icons.task_alt),
            label: 'Задачи',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.star_border_outlined),
            activeIcon: Icon(Icons.star_border),
            label: 'Навыки',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.diamond_outlined),
            activeIcon: Icon(Icons.diamond),
            label: 'Достижения',
          ),
        ],
        
    );
  }
  
}