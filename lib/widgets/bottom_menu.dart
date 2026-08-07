import 'package:flutter/material.dart';
import 'package:life_game/screens/home/home_model.dart';
import 'package:provider/provider.dart';

class BottomMenu extends StatelessWidget {
  const BottomMenu({super.key});

  @override
  Widget build(BuildContext context) {
    
    int currentTabId = context.select<HomeModel,int>((model) => model.currentTab);

    return BottomNavigationBar(
        onTap: context.read<HomeModel>().selectTab,
        currentIndex: currentTabId,
        
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.checklist_outlined),
            activeIcon: Icon(Icons.checklist),
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
          BottomNavigationBarItem(
            icon: Icon(Icons.bar_chart_outlined),
            activeIcon: Icon(Icons.bar_chart),
            label: 'Аналитика',
          ),
          
        ],
        
    );
  }
  
}