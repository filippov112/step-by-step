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
    var user = context.select<HomeModel,Profile?>((service) => service.user);

    return FutureBuilder(
      future: context.read<HomeModel>().loadUser(),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        return user == null ? ProfileFormScreen() : module.widget;
      }
    );
  }
}