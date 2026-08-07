import 'package:flutter/material.dart';
import 'package:life_game/models/user.dart';
import 'package:life_game/screens/achievements/achievement_list_screen.dart';
import 'package:life_game/screens/analysis/analysis_screen.dart';
import 'package:life_game/screens/home/home_model.dart';
import 'package:life_game/screens/skills/list/skill_list_screen.dart';
import 'package:life_game/screens/user/create/user_create_screen.dart';
import 'package:life_game/screens/tasks/list/task_list_screen.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    int tabId = context.select<HomeModel,int>((model) => model.currentTab);
    var user = context.select<HomeModel,User?>((service) => service.user);

    var tabs = IndexedStack(
        index: tabId,
        children: [
          TaskListScreen(),
          SkillListScreen(),
          AchievementListScreen(),
          AnalysisScreen(),
        ],
      );

    return FutureBuilder(
      future: context.read<HomeModel>().loadUser(),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        return user == null ? UserCreateScreen() : tabs;
      }
    );
  }
}