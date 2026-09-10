import 'package:chaos_control/screens/records/record_form_model.dart';
import 'package:chaos_control/services/notifications/notification_service.dart';
import 'package:flutter/material.dart';
import 'package:chaos_control/data/db.dart';
import 'package:chaos_control/screens/purports/detail/purport_details_model.dart';
import 'package:chaos_control/screens/purports/form/purport_form_model.dart';
import 'package:chaos_control/screens/purports/list/purport_list_model.dart';
import 'package:chaos_control/screens/home/home_model.dart';
import 'package:chaos_control/screens/home/home_screen.dart';
import 'package:chaos_control/screens/settings/setting_list_model.dart';
import 'package:chaos_control/screens/records/record_list_model.dart';
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
        ChangeNotifierProvider<NotificationService>(create: (_) => NotificationService()),
        ChangeNotifierProvider<HomeModel>(create: (_) { return HomeModel(); }),

        // Records
        ChangeNotifierProvider<RecordFormModel>(create: (_) { return RecordFormModel(); }),
        ChangeNotifierProvider<RecordListModel>(create: (_) { return RecordListModel(); }),
        
        // User
        ChangeNotifierProvider<ProfileFormModel>(create: (_) { return ProfileFormModel(); }),
        ChangeNotifierProvider<ProfileDetailModel>(create: (_) { return ProfileDetailModel(); }),
        
        // Settings
        ChangeNotifierProvider<SettingListModel>(create: (_) { return SettingListModel(); }),

        // Purports
        ChangeNotifierProvider<PurportListModel>(create: (_) { return PurportListModel(); }),
        ChangeNotifierProvider<PurportDetailsModel>(create: (_) { return PurportDetailsModel(); }),
        ChangeNotifierProvider<PurportFormModel>(create: (_) { return PurportFormModel(); }),
        
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
      title: 'Chaos Control',
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

