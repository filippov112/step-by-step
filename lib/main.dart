import 'package:flutter/material.dart';
import 'package:life_game/data/db.dart';
import 'package:life_game/screens/achievements/achievement_list_model.dart';
import 'package:life_game/screens/analysis/analysis_model.dart';
import 'package:life_game/screens/home/home_model.dart';
import 'package:life_game/screens/home/home_screen.dart';
import 'package:life_game/screens/settings/setting_list_model.dart';
import 'package:life_game/screens/skills/create/skill_create_model.dart';
import 'package:life_game/screens/skills/list/skill_list_model.dart';
import 'package:life_game/screens/skills/view/skill_view_model.dart';
import 'package:life_game/screens/tags/tag_list_model.dart';
import 'package:life_game/screens/tasks/view/task_view_model.dart';
import 'package:life_game/screens/user/create/user_create_model.dart';
import 'package:life_game/screens/tasks/create/task_create_model.dart';
import 'package:life_game/screens/tasks/list/task_list_model.dart';
import 'package:life_game/screens/user/view/user_view_model.dart';
import 'package:life_game/themes/solo_leveling_theme.dart';
import 'package:provider/provider.dart';

Future main() async {
  await DB.initDb();


  runApp(
    MultiProvider(
      providers: [

        // Home
        ChangeNotifierProvider<HomeModel>(create: (_) { return HomeModel(); }),

        // Tasks
        ChangeNotifierProvider<TaskListModel>(create: (_) { return TaskListModel(); }),
        ChangeNotifierProvider<TaskCreateModel>(create: (_) { return TaskCreateModel(); }),
        ChangeNotifierProvider<TaskViewModel>(create: (_) { return TaskViewModel(); }),
        
        // User
        ChangeNotifierProvider<UserCreateModel>(create: (_) { return UserCreateModel(); }),
        ChangeNotifierProvider<UserViewModel>(create: (_) { return UserViewModel(); }),
        
        // Tags
        ChangeNotifierProvider<TagListModel>(create: (_) { return TagListModel(); }),

        // Skills
        ChangeNotifierProvider<SkillCreateModel>(create: (_) { return SkillCreateModel(); }),
        ChangeNotifierProvider<SkillViewModel>(create: (_) { return SkillViewModel(); }),
        ChangeNotifierProvider<SkillListModel>(create: (_) { return SkillListModel(); }),
        
        // Settings
        ChangeNotifierProvider<SettingListModel>(create: (_) { return SettingListModel(); }),

        // Analysis
        ChangeNotifierProvider<AnalysisModel>(create: (_) { return AnalysisModel(); }),

        // Achievements
        ChangeNotifierProvider<AchievementListModel>(create: (_) { return AchievementListModel(); }),

        // Provider<IUserService>(create: (_) => UserServiceImpl()),
      ],
      child: MyApp(),
    )
  );
}


class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return  MaterialApp(
      title: 'Chaos Control',
      theme: SoloLevelingTheme.theme,
      home: HomeScreen()
    );
  }
}


