import 'package:flutter/material.dart';
import 'package:chaos_control/data/db.dart';
import 'package:chaos_control/screens/landmarks/detail/achievement_details_model.dart';
import 'package:chaos_control/screens/landmarks/form/achievement_form_model.dart';
import 'package:chaos_control/screens/landmarks/list/achievement_list_model.dart';
import 'package:chaos_control/screens/projects/detail/project_detail_model.dart';
import 'package:chaos_control/screens/projects/form/project_form_model.dart';
import 'package:chaos_control/screens/projects/list/project_list_model.dart';
import 'package:chaos_control/screens/home/home_model.dart';
import 'package:chaos_control/screens/home/home_screen.dart';
import 'package:chaos_control/screens/settings/setting_list_model.dart';
import 'package:chaos_control/screens/walls/form/task_form_model.dart';
import 'package:chaos_control/screens/walls/list/task_list_model.dart';
import 'package:chaos_control/screens/profile/form/profile_form_model.dart';
import 'package:chaos_control/screens/profile/detail/profile_detail_model.dart';
import 'package:chaos_control/themes/solo_leveling_theme.dart';
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
        ChangeNotifierProvider<ProfileFormModel>(create: (_) { return ProfileFormModel(); }),
        ChangeNotifierProvider<ProfileDetailModel>(create: (_) { return ProfileDetailModel(); }),
        
        // Settings
        ChangeNotifierProvider<SettingListModel>(create: (_) { return SettingListModel(); }),

        // Achievements
        ChangeNotifierProvider<AchievementListModel>(create: (_) { return AchievementListModel(); }),
        ChangeNotifierProvider<AchievementDetailsModel>(create: (_) { return AchievementDetailsModel(); }),
        ChangeNotifierProvider<AchievementFormModel>(create: (_) { return AchievementFormModel(); }),
        
        // Classes
        ChangeNotifierProvider<ProjectListModel>(create: (_) { return ProjectListModel(); }),
        ChangeNotifierProvider<ProjectDetailModel>(create: (_) { return ProjectDetailModel(); }),
        ChangeNotifierProvider<ProjectFormModel>(create: (_) { return ProjectFormModel(); }),
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
      // home: TestScreen()
    );
  }
}

