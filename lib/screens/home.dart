import 'dart:io';

import 'package:flutter/material.dart';
import 'package:life_game/screens/settings_screen.dart';
import 'package:life_game/screens/stats_screen.dart';
import 'package:life_game/screens/tasks/list/task_list_screen.dart';
import 'package:life_game/services/state_service.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  String? get iconPath => StateService.profile?.icon;
  int _currentTab = 1;

  @override
  Widget build(BuildContext context) { // Виджет родитель
    // Верстка
    return Scaffold(
      body: IndexedStack(
        index: _currentTab,  // 0, 1, 2
        children: [
          StatsScreen(),  // индекс 0
          TaskListScreen(),  // индекс 1
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
        currentIndex: _currentTab,
        items: <BottomNavigationBarItem> [
          BottomNavigationBarItem(
            icon: CircleAvatar(
              backgroundImage: StateService.profile?.icon != null ? FileImage(File(StateService.profile?.icon ?? "")) : null,
              child: StateService.profile?.icon == null ? const Icon(Icons.add_photo_alternate) : null,
            ),
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