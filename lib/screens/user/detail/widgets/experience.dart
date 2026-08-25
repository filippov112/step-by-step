import 'package:flutter/material.dart';
import 'package:chaos_control/screens/user/detail/user_detail_model.dart';
import 'package:chaos_control/screens/user/detail/widgets/user_progress.dart';
import 'package:chaos_control/services/exp_calculator.dart';
import 'package:provider/provider.dart';
import 'package:snap_chart/snap_chart.dart';

class UserDetailExp extends StatelessWidget {
  const UserDetailExp({super.key});

  @override
  Widget build(BuildContext context) {
    final exp = context.select<UserDetailModel, int>((model) => model.user?.experience ?? 0);

    final int deltaExp = context.select<UserDetailModel, int>(
      (model) => model.deltaExp,
    );
    final DateTime firstDay = context.select<UserDetailModel, DateTime>(
      (model) => model.firstDay,
    );
    final DateTime lastDay = context.select<UserDetailModel, DateTime>(
      (model) => model.lastDay,
    );
    final List<SnapSpot> progressExpData = context
        .select<UserDetailModel, List<SnapSpot>>(
          (model) => model.progressExpData,
        );

    return UserProgress(
      level: ExpCalculator.getLevel(exp),
      deltaValue: deltaExp.toDouble(),
      currentValue: ExpCalculator.getRemains(exp).toDouble(),
      title: 'Эксперт',
      nextLevel: ExpCalculator.getRequirements(exp).toDouble(),
      icon: Icons.wb_incandescent,
      data: progressExpData,
      firstDay: firstDay,
      lastDay: lastDay,
    );
  }
}