import 'package:flutter/material.dart';
import 'package:life_game/models/user.dart';
import 'package:life_game/screens/home/home_model.dart';
import 'package:life_game/screens/user/form/user_form_screen.dart';
import 'package:life_game/screens/home/widgets/modules.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {

    var module = context.select<HomeModel,AppModule>((model) => model.currentModule);
    var user = context.select<HomeModel,User?>((service) => service.user);

    return FutureBuilder(
      future: context.read<HomeModel>().loadUser(),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        return user == null ? UserFormScreen() : module.widget;
      }
    );
  }
}