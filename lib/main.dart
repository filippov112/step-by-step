import 'package:step_by_step/screens/records/record_form_model.dart';
import 'package:step_by_step/services/notifications/notification_service.dart';
import 'package:step_by_step/services/settings/settings_service.dart';
import 'package:step_by_step/services/sound_service.dart';
import 'package:step_by_step/services/hours_calculator.dart';
import 'package:flutter/material.dart';
import 'package:step_by_step/data/db.dart';
import 'package:step_by_step/screens/home/home_model.dart';
import 'package:step_by_step/screens/home/home_screen.dart';
import 'package:step_by_step/screens/settings/setting_list_model.dart';
import 'package:step_by_step/screens/records/record_list_model.dart';
import 'package:step_by_step/screens/profile/form/profile_form_model.dart';
import 'package:step_by_step/screens/profile/detail/profile_detail_model.dart';
import 'package:step_by_step/themes/solo_leveling_theme.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  final settingsService = await SettingsService.create();
  final calculator = HoursCalculator(settingsService);
  final soundService = SoundService();
  await soundService.init();
  await DB.initDb();

  runApp(
    MultiProvider(
      providers: [
        // Home
        ChangeNotifierProvider<NotificationService>(create: (_) => NotificationService()),
        ChangeNotifierProvider<HomeModel>(create: (_) { return HomeModel(); }),

        // Records
        ChangeNotifierProvider<RecordFormModel>(create: (_) { return RecordFormModel(calculator); }),
        ChangeNotifierProvider<RecordListModel>(create: (_) { return RecordListModel(calculator); }),
        
        // User
        ChangeNotifierProvider<ProfileFormModel>(create: (_) { return ProfileFormModel(calculator); }),
        ChangeNotifierProvider<ProfileDetailModel>(create: (_) { return ProfileDetailModel(calculator); }),
        
        // Settings
        ChangeNotifierProvider<SettingListModel>(create: (_) { return SettingListModel(settingsService); }),
        ChangeNotifierProvider<HoursCalculator>(create: (_) { return calculator;}),
        ChangeNotifierProvider<SoundService>(create: (_) { return soundService; }),
      ],
      child: MyApp(),
    )
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  @override
  Widget build(BuildContext context) {
    return  MaterialApp(
      title: 'Step By Step',
      theme: SoloLevelingTheme.theme,
      builder: (context, child) {
        return Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/images/back.png'),
              fit: BoxFit.cover,
            ),
          ),
          child: child,
        );
      },
      home: HomeScreen()
      // home: TestScreen()
    );
  }
}

