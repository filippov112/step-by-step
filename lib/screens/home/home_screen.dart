import 'package:flutter/material.dart';
import 'package:life_game/models/user.dart';
import 'package:life_game/screens/achievements/list/achievement_list_screen.dart';
import 'package:life_game/screens/home/home_model.dart';
import 'package:life_game/screens/skills/list/skill_list_screen.dart';
import 'package:life_game/screens/tasks/list/task_list_screen.dart';
import 'package:life_game/screens/user/form/user_form_screen.dart';
import 'package:life_game/screens/user/detail/user_detail_screen.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  Widget getPage(HomeModel model) {
    switch (model.currentTab) {
      case 0:
      return UserDetailScreen();
      case 2:
      return SkillListScreen();
      case 3:
      return AchievementListScreen();
      default:
      return TaskListScreen();
    }
  }

  @override
  Widget build(BuildContext context) {

    var model = context.read<HomeModel>();
    var user = context.select<HomeModel,User?>((service) => service.user);

    return FutureBuilder(
      future: context.read<HomeModel>().loadUser(),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        return user == null ? UserFormScreen() : getPage(model);
      }
    );
  }
}