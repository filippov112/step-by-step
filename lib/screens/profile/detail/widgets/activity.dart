import 'package:flutter/material.dart';
import 'package:chaos_control/screens/profile/detail/profile_detail_model.dart';
import 'package:chaos_control/widgets/analysis/custom_activity_table.dart';
import 'package:chaos_control/widgets/common/custom_card_block.dart';
import 'package:provider/provider.dart';

// Виджет отображения активности пользователя
class ProfileDetailActivity extends StatefulWidget {
  const ProfileDetailActivity({super.key});

  @override
  State<ProfileDetailActivity> createState() => _ProfileDetailActivityState();
}

enum ProfileActivityType { time, exp, tasks }

class _ProfileDetailActivityState extends State<ProfileDetailActivity> {
  ProfileActivityType selectedType = ProfileActivityType.tasks;

  @override
  Widget build(BuildContext context) {
    final Map<DateTime, int> tasks = context
        .select<ProfileDetailModel, Map<DateTime, int>>((model) => model.tasks);
    final Map<DateTime, int> experiences = context
        .select<ProfileDetailModel, Map<DateTime, int>>(
          (model) => model.experiences,
        );
    final Map<DateTime, int> times = context
        .select<ProfileDetailModel, Map<DateTime, int>>((model) => model.times);
    final int maxExp = context.select<ProfileDetailModel, int>(
      (model) => model.maxExp,
    );
    final int maxTime = context.select<ProfileDetailModel, int>(
      (model) => model.maxTime,
    );
    final int maxTasksCount = context.select<ProfileDetailModel, int>(
      (model) => model.maxTasksCount,
    );
    final DateTime firstDay = context.select<ProfileDetailModel, DateTime>(
      (model) => model.firstDay,
    );
    final DateTime lastDay = context.select<ProfileDetailModel, DateTime>(
      (model) => model.lastDay,
    );

    Map<DateTime, int> getData() {
      switch (selectedType) {
        case ProfileActivityType.time:
          return times;
        case ProfileActivityType.exp:
          return experiences;
        default:
          return tasks;
      }
    }

    int getMaxValue() {
      switch (selectedType) {
        case ProfileActivityType.time:
          return maxTime;
        case ProfileActivityType.exp:
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
              color: selectedType == ProfileActivityType.tasks
                  ? Theme.of(context).focusColor
                  : Theme.of(context).dividerColor,
              onPressed: () =>
                  setState(() => selectedType = ProfileActivityType.tasks),
              icon: Icon(Icons.task_alt_outlined),
            ),
          ),
          Padding(
            padding: EdgeInsetsGeometry.only(left: 8),
            child: IconButton(
              color: selectedType == ProfileActivityType.exp
                  ? Theme.of(context).focusColor
                  : Theme.of(context).dividerColor,
              onPressed: () =>
                  setState(() => selectedType = ProfileActivityType.exp),
              icon: Icon(Icons.wb_incandescent),
            ),
          ),
          Padding(
            padding: EdgeInsetsGeometry.only(left: 8),
            child: IconButton(
              color: selectedType == ProfileActivityType.time
                  ? Theme.of(context).focusColor
                  : Theme.of(context).dividerColor,
              onPressed: () =>
                  setState(() => selectedType = ProfileActivityType.time),
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
