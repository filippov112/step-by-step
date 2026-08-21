import 'dart:io';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:life_game/models/achievement.dart';
import 'package:life_game/models/user.dart';
import 'package:life_game/screens/user/detail/user_detail_model.dart';
import 'package:life_game/screens/user/detail/widgets/accumulation.dart';
import 'package:life_game/widgets/analysis/custom_activity_table.dart';
import 'package:life_game/services/exp_calculator.dart';
import 'package:life_game/widgets/analysis/custom_rose_chart.dart';
import 'package:life_game/widgets/common/custom_text.dart';
import 'package:life_game/widgets/main/main_app_bar.dart';
import 'package:life_game/widgets/main/main_bottom_menu.dart';
import 'package:life_game/widgets/main/main_menu_drawer.dart';
import 'package:provider/provider.dart';
import 'package:snap_chart/snap_chart.dart';


class UserDetailScreen extends StatefulWidget {
  const UserDetailScreen({
    super.key,
  });

  @override
  State<UserDetailScreen> createState() => _UserDetailScreenState();
}

class _UserDetailScreenState extends State<UserDetailScreen> {

  Map<DateTime, int> _getUserActivities(int cnt) {
    final activities = <DateTime, int>{};
    final now = DateTime.now();
    
    // Генерируем демо-данные
    for (int i = 0; i < cnt; i++) {
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
        title: Text(_formatDate(date)),
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

    var expWidget = AccumulationDynamic(
      level: ExpCalculator.getLevel(user.experience),
      deltaValue: 0,
      currentValue: ExpCalculator.getRemains(user.experience).toDouble(),
      title: 'Опыт',
      nextLevel: ExpCalculator.getRequirements(user.experience).toDouble(),
      icon: Icons.stars,
      oldData: [
        SnapSpot(DateTime(2026, 1, 1).millisecondsSinceEpoch.toDouble(), 3),
         SnapSpot(DateTime(2026,2,1).millisecondsSinceEpoch.toDouble(), 4),
         SnapSpot(DateTime(2026,4,1).millisecondsSinceEpoch.toDouble(), 8),
         SnapSpot(DateTime(2026,5,1).millisecondsSinceEpoch.toDouble(), 8.5),
      ],
      newData: [
         SnapSpot(DateTime(2026,5,1).millisecondsSinceEpoch.toDouble(), 8.5),
         SnapSpot(DateTime(2026, 7, 1).millisecondsSinceEpoch.toDouble(), 12),
         SnapSpot(DateTime(2026,8,1).millisecondsSinceEpoch.toDouble(), 13),
      ],
      firstDay: DateTime(2026,1,1),
      lastDay: DateTime(2026,8,1),
      firstDayDelta: DateTime(2026,5,1),
    );

    var countDays = 7;
    var dayData = _getUserActivities(countDays);
    var maxv = dayData.values.reduce(max);
    var activity = CustomActivityTable(
      activities: dayData,
      maxValue: maxv,
      startDate: DateTime.now().subtract(Duration(days: countDays - 1)),
      endDate: DateTime.now(),
      cellSpacing: 3,
      showMonthLabels: true,
      showWeekLabels: true,
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
            child: ListView(
              children: [
                Column(
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

                  
                  CustomRoseChart()
   
                ]
                ) 
              ] 
            )
          ),
          bottomNavigationBar: MainBottomMenu(),
        );
      }
    );
  }
}

