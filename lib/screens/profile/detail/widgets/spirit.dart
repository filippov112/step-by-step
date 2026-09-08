import 'package:flutter/material.dart';
import 'package:chaos_control/screens/profile/detail/profile_detail_model.dart';
import 'package:chaos_control/screens/profile/detail/widgets/progress.dart';
import 'package:chaos_control/services/spirit_calculator.dart';
import 'package:provider/provider.dart';
import 'package:snap_chart/snap_chart.dart';

class ProfileDetailSpirit extends StatelessWidget {
  const ProfileDetailSpirit({super.key});

  @override
  Widget build(BuildContext context) {
    final eff = context.select<ProfileDetailModel, int>((model) => model.user?.spiritFragments ?? 0);

    final int deltaEff = context.select<ProfileDetailModel, int>(
      (model) => model.deltaSF,
    );
    final DateTime firstDay = context.select<ProfileDetailModel, DateTime>(
      (model) => model.firstDay,
    );
    final DateTime lastDay = context.select<ProfileDetailModel, DateTime>(
      (model) => model.lastDay,
    );
    final List<SnapSpot> progressData = context
        .select<ProfileDetailModel, List<SnapSpot>>(
          (model) => model.progressSFData,
        );

    return ProfileProgress(
      level: SpiritCalculator.getLevel(eff),
      deltaValue: deltaEff.toDouble(),
      currentValue: SpiritCalculator.getLevelRemains(eff).toDouble(),
      title: 'Дух',
      nextLevel: SpiritCalculator.getLevelRequirements(eff).toDouble(),
      icon: Icons.local_fire_department,
      data: progressData,
      firstDay: firstDay,
      lastDay: lastDay,
    );
  }
}