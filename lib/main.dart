import 'package:flutter/material.dart';
import 'package:life_game/data/db.dart';
import 'package:life_game/screens/achievements/detail/achievement_details_model.dart';
import 'package:life_game/screens/achievements/form/achievement_form_model.dart';
import 'package:life_game/screens/achievements/list/achievement_list_model.dart';
import 'package:life_game/screens/classes/detail/class_detail_model.dart';
import 'package:life_game/screens/classes/form/class_form_model.dart';
import 'package:life_game/screens/classes/list/class_list_model.dart';
import 'package:life_game/screens/home/home_model.dart';
import 'package:life_game/screens/home/home_screen.dart';
import 'package:life_game/screens/settings/setting_list_model.dart';
import 'package:life_game/screens/skills/form/skill_form_model.dart';
import 'package:life_game/screens/tasks/form/widgets/skill_list_model.dart';
import 'package:life_game/screens/skills/detail/skill_detail_model.dart';
import 'package:life_game/screens/tags/tag_list_model.dart';
import 'package:life_game/screens/tasks/form/task_form_model.dart';
import 'package:life_game/screens/tasks/list/task_list_model.dart';
import 'package:life_game/screens/user/form/user_form_model.dart';
import 'package:life_game/screens/user/detail/user_detail_model.dart';
import 'package:life_game/themes/solo_leveling_theme.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

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

        // Achievements
        ChangeNotifierProvider<AchievementListModel>(create: (_) { return AchievementListModel(); }),
        ChangeNotifierProvider<AchievementDetailsModel>(create: (_) { return AchievementDetailsModel(); }),
        ChangeNotifierProvider<AchievementFormModel>(create: (_) { return AchievementFormModel(); }),
        
        // Classes
        ChangeNotifierProvider<ClassListModel>(create: (_) { return ClassListModel(); }),
        ChangeNotifierProvider<ClassDetailModel>(create: (_) { return ClassDetailModel(); }),
        ChangeNotifierProvider<ClassFormModel>(create: (_) { return ClassFormModel(); }),
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

