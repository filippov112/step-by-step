import 'package:flutter/material.dart';
import 'package:chaos_control/screens/profile/detail/profile_detail_model.dart';
import 'package:chaos_control/screens/profile/detail/widgets/progress.dart';
import 'package:chaos_control/services/exp_calculator.dart';
import 'package:provider/provider.dart';
import 'package:snap_chart/snap_chart.dart';

class ProfileDetailTime extends StatelessWidget {
  const ProfileDetailTime({super.key});

  @override
  Widget build(BuildContext context) {
    final time = context.select<ProfileDetailModel, int>((model) => model.user?.experience ?? 0);
    final int deltaTime = context.select<ProfileDetailModel, int>(
      (model) => model.deltaTime,
    );
    final DateTime firstDay = context.select<ProfileDetailModel, DateTime>(
      (model) => model.firstDay,
    );
    final DateTime lastDay = context.select<ProfileDetailModel, DateTime>(
      (model) => model.lastDay,
    );
    final List<SnapSpot> progressTimeData = context
      .select<ProfileDetailModel, List<SnapSpot>>(
        (model) => model.progressTimeData,
      );

    return ProfileProgress(
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