import 'package:flutter/material.dart';
import 'package:chaos_control/screens/profile/detail/profile_detail_model.dart';
import 'package:chaos_control/screens/profile/detail/widgets/progress.dart';
import 'package:chaos_control/services/exp_calculator.dart';
import 'package:provider/provider.dart';
import 'package:snap_chart/snap_chart.dart';

class ProfileDetailExp extends StatelessWidget {
  const ProfileDetailExp({super.key});

  @override
  Widget build(BuildContext context) {
    final exp = context.select<ProfileDetailModel, int>((model) => model.user?.experience ?? 0);

    final int deltaExp = context.select<ProfileDetailModel, int>(
      (model) => model.deltaExp,
    );
    final DateTime firstDay = context.select<ProfileDetailModel, DateTime>(
      (model) => model.firstDay,
    );
    final DateTime lastDay = context.select<ProfileDetailModel, DateTime>(
      (model) => model.lastDay,
    );
    final List<SnapSpot> progressExpData = context
        .select<ProfileDetailModel, List<SnapSpot>>(
          (model) => model.progressExpData,
        );

    return ProfileProgress(
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