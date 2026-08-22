import 'package:flutter/material.dart';
import 'package:life_game/screens/user/detail/user_detail_model.dart';
import 'package:life_game/screens/user/detail/widgets/user_progress.dart';
import 'package:life_game/services/exp_calculator.dart';
import 'package:provider/provider.dart';
import 'package:snap_chart/snap_chart.dart';

class UserDetailTime extends StatelessWidget {
  const UserDetailTime({super.key});

  @override
  Widget build(BuildContext context) {
    final time = context.select<UserDetailModel, int>((model) => model.user?.experience ?? 0);
    final int deltaTime = context.select<UserDetailModel, int>(
      (model) => model.deltaTime,
    );
    final DateTime firstDay = context.select<UserDetailModel, DateTime>(
      (model) => model.firstDay,
    );
    final DateTime lastDay = context.select<UserDetailModel, DateTime>(
      (model) => model.lastDay,
    );
    final List<SnapSpot> progressTimeData = context
      .select<UserDetailModel, List<SnapSpot>>(
        (model) => model.progressTimeData,
      );

    return UserProgress(
      level: ExpCalculator.getLevel(time),
      deltaValue: deltaTime.toDouble(),
      currentValue: ExpCalculator.getRemains(time).toDouble(),
      title: 'Мастер',
      nextLevel: ExpCalculator.getRequirements(time).toDouble(),
      icon: Icons.schedule_outlined,
      data: progressTimeData,
      firstDay: firstDay,
      lastDay: lastDay,
    );
  }
}