import 'dart:io';
import 'package:flutter/material.dart';
import 'package:life_game/models/user.dart';
import 'package:life_game/screens/user/view/user_view_model.dart';
import 'package:life_game/themes/solo_leveling_theme.dart';
import 'package:life_game/widgets/bottom_menu.dart';
import 'package:life_game/widgets/custom_progress_bar.dart';
import 'package:provider/provider.dart';


class UserViewScreen extends StatelessWidget {
  const UserViewScreen({super.key});
  
  @override
  Widget build(BuildContext context) {

    User user = context.select<UserViewModel,User?>((model) => model.user) ?? User(dateBirth: DateTime(2000));

    var avaterWidget = Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(width: 2),
        boxShadow: [
          BoxShadow(
            blurRadius: 12,
            spreadRadius: 2,
            color: SoloLevelingTheme.iceBlue
          ),
        ],
      ),
      child: CircleAvatar(
        radius: 40,
        backgroundImage: FileImage(File(user?.icon ?? "")),
        onBackgroundImageError: (_, _) => const Icon(Icons.person, size: 40),
        child: user.icon == null
            ? const Icon(Icons.person, size: 40)
            : null,
      ),
    );

    var levelIconWidget = Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: SoloLevelingTheme.steelBlue,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            blurRadius: 12,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Text(
        user.level.toString(),
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 14,
          color: SoloLevelingTheme.textPrimary
        ),
      ),
    );

    var nameWidget = Text(
      user.name,
      style: const TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.bold,
        shadows: [
          Shadow(offset: Offset(1, 1), blurRadius: 4),
        ],
      ),
    );

    var ageWidget = Row(
      children: [
        const Icon(Icons.watch_later_sharp, size: 16),
        const SizedBox(width: 6),
        Text(
          user.age,
          style: const TextStyle(fontSize: 16),
        )
      ],
    );

    var expWidget = CustomProgressBar(
      label: 'Опыт',
      value: user.experience.toDouble(),
      maxValue: user.maxExperience.toDouble(),
      icon: Icons.stars,
      showAsPercent: false, // показываем X / Y
    );

    return FutureBuilder(
      future: context.read<UserViewModel>().loadUser(),

      builder: (BuildContext context, AsyncSnapshot snapshot) {
        return Scaffold(
          body: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Шапка: аватар, имя, возраст
                Row(
                  children: [
                    // Аватар с обводкой
                    avaterWidget,
                    const SizedBox(width: 16),
                    // Имя и возраст
                    Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          levelIconWidget,
                          const SizedBox(height: 4),
                          nameWidget,
                          const SizedBox(height: 4),
                          ageWidget
                        ],
                      ),
                  ],
                ),
                const SizedBox(height: 20),
                // Опыт
                expWidget,
              ],
            ),
          ),
          bottomNavigationBar: BottomMenu(),
        );
      }
    );
  }
}
