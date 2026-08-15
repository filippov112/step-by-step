import 'dart:io';
import 'package:flutter/material.dart';
import 'package:life_game/models/achievement.dart';
import 'package:life_game/models/user.dart';
import 'package:life_game/screens/user/detail/user_detail_model.dart';
import 'package:life_game/themes/solo_leveling_theme.dart';
import 'package:life_game/widgets/common/custom_text.dart';
import 'package:life_game/widgets/main/main_app_bar.dart';
import 'package:life_game/widgets/main/main_menu_drawer.dart';
import 'package:life_game/widgets/main/main_bottom_menu.dart';
import 'package:life_game/screens/user/detail/widgets/custom_progress_bar.dart';
import 'package:provider/provider.dart';


class UserDetailScreen extends StatelessWidget {
  const UserDetailScreen({super.key});
  
  @override
  Widget build(BuildContext context) {

    User user = context.select<UserDetailModel,User?>((model) => model.user) ?? User(dateBirth: DateTime(2000));

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
        backgroundImage: FileImage(File(user.icon ?? "")),
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

    var nameWidget = CustomText(
      user.name,
      size: 24,
      weight: FontWeight.bold,
      shadow: const Shadow(offset: Offset(1, 1), blurRadius: 4),
    );

    var ageWidget = Row(
      children: [
        const Icon(Icons.watch_later_sharp, size: 16),
        const SizedBox(width: 6),
        CustomText(
          user.age,
          size: 16, expanded: true,
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
      future: context.read<UserDetailModel>().loadUser(),

      builder: (BuildContext context, AsyncSnapshot snapshot) {
        return Scaffold(
          drawer: MainMenuDrawer(),
          appBar: buildMainAppBar<Achievement>(
            context,
            title: 'Профиль',
            isRootWidgetTree: true,
            isSelectionMode: false,
            selectAll: (){},
            selectedIds: [],
            filteredList: [],
            deleteSelected: (){},
            clearSelection: (){},
          ),
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
                    Expanded( child:Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          levelIconWidget,
                          const SizedBox(height: 4),
                          nameWidget,
                          const SizedBox(height: 4),
                          ageWidget
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                // Опыт
                expWidget,
              ],
            ),
          ),
          bottomNavigationBar: MainBottomMenu(),
        );
      }
    );
  }
}
