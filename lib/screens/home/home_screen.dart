import 'package:chaos_control/services/notifications/notification_service.dart';
import 'package:flutter/material.dart';
import 'package:chaos_control/models/profile.dart';
import 'package:chaos_control/screens/home/home_model.dart';
import 'package:chaos_control/screens/profile/form/profile_form_screen.dart';
import 'package:chaos_control/screens/home/widgets/modules.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {

    var module = context.select<HomeModel,AppModule>((model) => model.currentModule);
    var profile = context.select<HomeModel,Profile?>((service) => service.profile);

    // Инициализация сервиса уведомлений
    final ns = context.read<NotificationService>();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ns.setContext(context);
    });

    return FutureBuilder(
      future: context.read<HomeModel>().loadData(),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        return profile == null ? ProfileFormScreen() : module.widget;
      }
    );
  }
}