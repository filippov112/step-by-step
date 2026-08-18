import 'dart:io';
import 'package:flutter/material.dart';
import 'package:life_game/models/achievement.dart';
import 'package:life_game/models/user.dart';
import 'package:life_game/screens/user/detail/user_detail_model.dart';
import 'package:life_game/screens/user/detail/widgets/accumulation.dart';
import 'package:life_game/screens/user/detail/widgets/activities.dart';
import 'package:life_game/widgets/common/custom_text.dart';
import 'package:life_game/widgets/main/main_app_bar.dart';
import 'package:life_game/widgets/main/main_bottom_menu.dart';
import 'package:life_game/widgets/main/main_menu_drawer.dart';
import 'package:provider/provider.dart';
import 'package:radar_chart_plus/radar_chart_plus.dart';
import 'package:snap_chart/snap_chart.dart';


class UserDetailScreen extends StatefulWidget {
  const UserDetailScreen({
    super.key,
  });

  @override
  State<UserDetailScreen> createState() => _UserDetailScreenState();
}

class _UserDetailScreenState extends State<UserDetailScreen> {

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
      level: user.level,
      deltaValue: 2,
      currentValue: 11,
      title: 'Опыт',
      // value: user.experience.toDouble(),
      nextLevel: user.maxExperience.toDouble(),
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

                  
                  SizedBox(height: 400, child: RadarChartPlus(
                    ticks: [2, 4, 6],
                    labels: ['AA', 'BB', 'CC'],
                    dataSets: [
                      RadarDataSet(
                        data: [3, 2, 5],
                        borderColor: Color(0xFF8072F3),
                        fillColor: Color(0x668072F3),
                        dotColor: Color(0xFF8072F3),
                      ),
                    ],
                  )),
   
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

