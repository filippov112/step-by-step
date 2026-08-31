import 'package:flutter/material.dart';
import 'package:chaos_control/screens/profile/detail/profile_detail_model.dart';
import 'package:chaos_control/screens/profile/detail/widgets/progress.dart';
import 'package:chaos_control/services/exp_calculator.dart';
import 'package:provider/provider.dart';
import 'package:snap_chart/snap_chart.dart';

class ProfileDetailSpirit extends StatelessWidget {
  const ProfileDetailSpirit({super.key});

  @override
  Widget build(BuildContext context) {
    final eff = context.select<ProfileDetailModel, int>((model) => model.user?.efforts ?? 0);

    final int deltaEff = context.select<ProfileDetailModel, int>(
      (model) => model.deltaEfforts,
    );
    final DateTime firstDay = context.select<ProfileDetailModel, DateTime>(
      (model) => model.firstDay,
    );
    final DateTime lastDay = context.select<ProfileDetailModel, DateTime>(
      (model) => model.lastDay,
    );
    final List<SnapSpot> progressData = context
        .select<ProfileDetailModel, List<SnapSpot>>(
          (model) => model.progressEffortData,
        );

    return ProfileProgress(
      level: SpiritCalculator.getLevel(eff),
      deltaValue: deltaEff.toDouble(),
      currentValue: SpiritCalculator.getRemains(eff).toDouble(),
      title: 'Дух',
      nextLevel: SpiritCalculator.getRequirements(eff).toDouble(),
      icon: Icons.local_fire_department,
      data: progressData,
      firstDay: firstDay,
      lastDay: lastDay,
    );
  }
}