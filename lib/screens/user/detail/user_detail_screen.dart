import 'dart:io';
import 'package:flutter/material.dart';
import 'package:life_game/models/achievement.dart';
import 'package:life_game/models/user.dart';
import 'package:life_game/screens/user/detail/user_detail_model.dart';
import 'package:life_game/screens/user/detail/widgets/activities.dart';
import 'package:life_game/widgets/common/custom_text.dart';
import 'package:life_game/widgets/main/main_app_bar.dart';
import 'package:life_game/widgets/main/main_menu_drawer.dart';
import 'package:life_game/widgets/main/main_bottom_menu.dart';
import 'package:life_game/screens/user/detail/widgets/custom_progress_bar.dart';
import 'package:provider/provider.dart';


class UserDetailScreen extends StatelessWidget {
  const UserDetailScreen({super.key});
  
  Map<DateTime, int> _getUserActivities() {
    final activities = <DateTime, int>{};
    final now = DateTime.now();
    
    // Генерируем демо-данные
    for (int i = 0; i < 365; i++) {
      final date = now.subtract(Duration(days: i));
      // Случайное количество задач (0-12)
      final count = (i % 7 == 0) ? 0 : (i % 13);
      activities[DateTime(date.year, date.month, date.day)] = count;
    }
    return activities;
  }

  void _showActivityDetails(BuildContext context, DateTime date, int count) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('${_formatDate(date)}'),
        content: Text('Выполнено задач: $count'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Закрыть'),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day} ${_getMonthName(date.month)} ${date.year}';
  }

  String _getMonthName(int month) {
    const months = ['января', 'февраля', 'марта', 'апреля', 'мая', 'июня', 
                    'июля', 'августа', 'сентября', 'октября', 'ноября', 'декабря'];
    return months[month - 1];
  }

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
            spreadRadius: 2
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
        color: Theme.of(context).dividerColor,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            blurRadius: 12,
            spreadRadius: 2,
          ),
        ],
      ),
      child: CustomText(
        user.level.toString(), weight: FontWeight.bold 
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

    var activity = ActivityGrid(
      activities: _getUserActivities(),
      startDate: DateTime.now().subtract(Duration(days: 70)),
      endDate: DateTime.now(),
      cellSpacing: 3,
      showMonthLabels: false,
      onCellTap: (date, count) {
        _showActivityDetails(context, date, count);
      },
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

                Padding(
                  padding: EdgeInsetsGeometry.only(top:8), 
                  child: SizedBox(
                    height: 150,
                    child: activity,
                  ),
                ),
                
              ],
            ),
          ),
          bottomNavigationBar: MainBottomMenu(),
        );
      }
    );
  }
}
