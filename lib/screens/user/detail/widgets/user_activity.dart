import 'package:flutter/material.dart';
import 'package:life_game/widgets/analysis/custom_activity_table.dart';
import 'package:life_game/widgets/common/custom_card_block.dart';

// Виджет отображения активности пользователя
class UserActivity extends StatefulWidget {
  final Map<DateTime, int> tasks;
  final Map<DateTime, int> experiences;
  final Map<DateTime, int> times;
  final int maxExp;
  final int maxTime;
  final int deltaExp;
  final int deltaTime;
  final int maxTasksCount;
  final DateTime firstDay;
  final DateTime lastDay;

  const UserActivity({
    super.key,
    required this.tasks,
    required this.experiences,
    required this.times,
    required this.maxExp,
    required this.maxTime,
    required this.deltaExp,
    required this.deltaTime,
    required this.maxTasksCount,
    required this.firstDay,
    required this.lastDay,
  });

  @override
  State<UserActivity> createState() => _UserActivityState();
}

enum UserActivityType { time, exp, tasks }

class _UserActivityState extends State<UserActivity> {
  UserActivityType selectedType = UserActivityType.tasks;

  Map<DateTime, int> _getData() {
    switch (selectedType) {
      case UserActivityType.time:
        return widget.times;
      case UserActivityType.exp:
        return widget.experiences;
      default:
        return widget.tasks;
    }
  }

  int _getMaxValue() {
    switch (selectedType) {
      case UserActivityType.time:
        return widget.maxTime;
      case UserActivityType.exp:
        return widget.maxExp;
      default:
        return widget.maxTasksCount;
    }
  }

  @override
  Widget build(BuildContext context) {
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
          activities: _getData(),
          maxValue: _getMaxValue(),
          startDate: widget.firstDay,
          endDate: widget.lastDay,
          cellSpacing: 3,
          showMonthLabels: true,
          showWeekLabels: true,
        ),
      ),
    );
  }
}
