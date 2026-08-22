import 'package:flutter/material.dart';
import 'package:life_game/screens/user/detail/user_detail_model.dart';
import 'package:life_game/widgets/analysis/custom_activity_table.dart';
import 'package:life_game/widgets/common/custom_card_block.dart';
import 'package:provider/provider.dart';

// Виджет отображения активности пользователя
class UserDetailActivity extends StatefulWidget {
  const UserDetailActivity({super.key});

  @override
  State<UserDetailActivity> createState() => _UserDetailActivityState();
}

enum UserActivityType { time, exp, tasks }

class _UserDetailActivityState extends State<UserDetailActivity> {
  UserActivityType selectedType = UserActivityType.tasks;

  @override
  Widget build(BuildContext context) {
    final Map<DateTime, int> tasks = context
        .select<UserDetailModel, Map<DateTime, int>>((model) => model.tasks);
    final Map<DateTime, int> experiences = context
        .select<UserDetailModel, Map<DateTime, int>>(
          (model) => model.experiences,
        );
    final Map<DateTime, int> times = context
        .select<UserDetailModel, Map<DateTime, int>>((model) => model.times);
    final int maxExp = context.select<UserDetailModel, int>(
      (model) => model.maxExp,
    );
    final int maxTime = context.select<UserDetailModel, int>(
      (model) => model.maxTime,
    );
    final int maxTasksCount = context.select<UserDetailModel, int>(
      (model) => model.maxTasksCount,
    );
    final DateTime firstDay = context.select<UserDetailModel, DateTime>(
      (model) => model.firstDay,
    );
    final DateTime lastDay = context.select<UserDetailModel, DateTime>(
      (model) => model.lastDay,
    );

    Map<DateTime, int> getData() {
      switch (selectedType) {
        case UserActivityType.time:
          return times;
        case UserActivityType.exp:
          return experiences;
        default:
          return tasks;
      }
    }

    int getMaxValue() {
      switch (selectedType) {
        case UserActivityType.time:
          return maxTime;
        case UserActivityType.exp:
          return maxExp;
        default:
          return maxTasksCount;
      }
    }

    return CustomCardBlock(
      title: 'Активность',
      icon: Icons.speed,
      trailing: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Тип данных
          Padding(
            padding: EdgeInsetsGeometry.only(left: 8),
            child: IconButton(
              color: selectedType == UserActivityType.tasks
                  ? Theme.of(context).focusColor
                  : Theme.of(context).dividerColor,
              onPressed: () =>
                  setState(() => selectedType = UserActivityType.tasks),
              icon: Icon(Icons.task_alt_outlined),
            ),
          ),
          Padding(
            padding: EdgeInsetsGeometry.only(left: 8),
            child: IconButton(
              color: selectedType == UserActivityType.exp
                  ? Theme.of(context).focusColor
                  : Theme.of(context).dividerColor,
              onPressed: () =>
                  setState(() => selectedType = UserActivityType.exp),
              icon: Icon(Icons.wb_incandescent),
            ),
          ),
          Padding(
            padding: EdgeInsetsGeometry.only(left: 8),
            child: IconButton(
              color: selectedType == UserActivityType.time
                  ? Theme.of(context).focusColor
                  : Theme.of(context).dividerColor,
              onPressed: () =>
                  setState(() => selectedType = UserActivityType.time),
              icon: Icon(Icons.schedule_outlined),
            ),
          ),
        ],
      ),
      child: SizedBox(
        height: 150,
        child: CustomActivityTable(
          activities: getData(),
          maxValue: getMaxValue(),
          startDate: firstDay,
          endDate: lastDay,
          cellSpacing: 3,
          showMonthLabels: true,
          showWeekLabels: true,
        ),
      ),
    );
  }
}
