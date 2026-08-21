import 'dart:io';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:life_game/models/achievement.dart';
import 'package:life_game/models/user.dart';
import 'package:life_game/screens/user/detail/user_detail_model.dart';
import 'package:life_game/screens/user/detail/widgets/user_activity.dart';
import 'package:life_game/screens/user/detail/widgets/user_progress.dart';
import 'package:life_game/screens/user/detail/widgets/user_info.dart';
import 'package:life_game/services/analytics_repository.dart';
import 'package:life_game/tools/format_date.dart';
import 'package:life_game/widgets/analysis/custom_activity_table.dart';
import 'package:life_game/services/exp_calculator.dart';
import 'package:life_game/widgets/analysis/custom_rose_chart.dart';
import 'package:life_game/widgets/common/custom_image_icon.dart';
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
  UserDetailModel? model;

  @override
  void initState() {
    super.initState();
    model = context.read<UserDetailModel>();
    model?.loadUser();
  }

  

  @override
  Widget build(BuildContext context) {

    User user = context.select<UserDetailModel,User?>((model) => model.user) ?? User(dateBirth: DateTime(2000));
    var daysData = context.select<UserDetailModel,List<DailyAggregate>?>((model) => model.daysData);

    var expWidget = UserProgress(
      level: ExpCalculator.getLevel(user.experience),
      deltaValue: 0,
      currentValue: ExpCalculator.getRemains(user.experience).toDouble(),
      title: 'Эксперт',
      nextLevel: ExpCalculator.getRequirements(user.experience).toDouble(),
      icon: Icons.wb_incandescent,
      data: [
        SnapSpot(DateTime(2026, 1, 1).millisecondsSinceEpoch.toDouble(), 3),
         SnapSpot(DateTime(2026,2,1).millisecondsSinceEpoch.toDouble(), 4),
         SnapSpot(DateTime(2026,4,1).millisecondsSinceEpoch.toDouble(), 8),
         SnapSpot(DateTime(2026,5,1).millisecondsSinceEpoch.toDouble(), 8.5),
      ],
      firstDay: DateTime(2026,1,1),
      lastDay: DateTime(2026,8,1),
      firstDayDelta: DateTime(2026,5,1),
    );

    var timeWidget = UserProgress(
      level: ExpCalculator.getLevel(user.time),
      deltaValue: 0,
      currentValue: ExpCalculator.getRemains(user.time).toDouble(),
      title: 'Мастер',
      nextLevel: ExpCalculator.getRequirements(user.time).toDouble(),
      icon: Icons.schedule_outlined,
      data: [
        SnapSpot(DateTime(2026, 1, 1).millisecondsSinceEpoch.toDouble(), 3),
         SnapSpot(DateTime(2026,2,1).millisecondsSinceEpoch.toDouble(), 4),
         SnapSpot(DateTime(2026,4,1).millisecondsSinceEpoch.toDouble(), 8),
         SnapSpot(DateTime(2026,5,1).millisecondsSinceEpoch.toDouble(), 8.5),
      ],
      firstDay: DateTime(2026,1,1),
      lastDay: DateTime(2026,8,1),
      firstDayDelta: DateTime(2026,5,1),
    );

  
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

              Userinfo(user: user),
              
              UserActivity(data: daysData ?? []),

              // Опыт
              expWidget,

              // Время
              timeWidget,
            ]
            ) 
          ] 
        )
      ),
      bottomNavigationBar: MainBottomMenu(),
    );
  }
}

