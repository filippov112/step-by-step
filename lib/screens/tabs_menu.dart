import 'package:flutter/material.dart';
import 'package:life_game/screens/settings_screen.dart';
import 'package:life_game/screens/stats_screen.dart';
import 'package:life_game/screens/tasks_screen.dart';

class TabsMenu extends StatefulWidget {
  const TabsMenu({super.key});

  // Тут входящие параметры виджета - final string title; Объявление полей всегда с final.

  @override
  State<TabsMenu> createState() => _TabsMenuState();
}

class _TabsMenuState extends State<TabsMenu> {
  // ViewModel - команды, свойства
  int _currentTab = 1;

  @override
  Widget build(BuildContext context) { // Виджет родитель
    // Верстка
    return Scaffold(
      body: IndexedStack(
        index: _currentTab,  // 0, 1, 2
        children: [
          StatsScreen(),  // индекс 0
          TasksScreen(),  // индекс 1
          SettingsScreen(),  // индекс 2
        ],
      ),    
      bottomNavigationBar: BottomNavigationBar(
        onTap: (newIndex) {
          setState(() {
            // Запускает build
            _currentTab = newIndex;
          });
        },
        items: const <BottomNavigationBarItem> [
          BottomNavigationBarItem(
            icon: Icon(Icons.bar_chart),
            label: 'Статистика',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.checklist),
            label: 'Задачи',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Настройки',
          ),
        ])
    );
  }
}