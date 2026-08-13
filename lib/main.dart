import 'package:flutter/material.dart';
import 'package:life_game/data/db.dart';
import 'package:life_game/screens/achievements/achievement_list_model.dart';
import 'package:life_game/screens/analysis/analysis_model.dart';
import 'package:life_game/screens/home/home_model.dart';
import 'package:life_game/screens/home/home_screen.dart';
import 'package:life_game/screens/settings/setting_list_model.dart';
import 'package:life_game/screens/skills/form/skill_form_model.dart';
import 'package:life_game/screens/skills/list/skill_list_model.dart';
import 'package:life_game/screens/skills/detail/skill_detail_model.dart';
import 'package:life_game/screens/tags/tag_list_model.dart';
import 'package:life_game/screens/tasks/detail/task_detail_model.dart';
import 'package:life_game/screens/tasks/form/task_form_model.dart';
import 'package:life_game/screens/tasks/list/task_list_model.dart';
import 'package:life_game/screens/user/form/user_form_model.dart';
import 'package:life_game/screens/user/detail/user_detail_model.dart';
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
        ChangeNotifierProvider<TaskFormModel>(create: (_) { return TaskFormModel(); }),
        // ChangeNotifierProvider<TaskDetailModel>(create: (_) { return TaskDetailModel(); }),
        ChangeNotifierProvider<TaskListModel>(create: (_) { return TaskListModel(); }),
        
        // User
        ChangeNotifierProvider<UserFormModel>(create: (_) { return UserFormModel(); }),
        ChangeNotifierProvider<UserDetailModel>(create: (_) { return UserDetailModel(); }),
        
        // Tags
        ChangeNotifierProvider<TagListModel>(create: (_) { return TagListModel(); }),

        // Skills
        ChangeNotifierProvider<SkillFormModel>(create: (_) { return SkillFormModel(); }),
        ChangeNotifierProvider<SkillDetailModel>(create: (_) { return SkillDetailModel(); }),
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


