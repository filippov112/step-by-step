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

  @override
  Widget build(BuildContext context) {
    final Map<DateTime, int> efforts = context
        .select<ProfileDetailModel, Map<DateTime, int>>(
          (model) => model.activityData,
        );
    final int maxEff = context.select<ProfileDetailModel, int>(
      (model) => model.maxSF,
    );
    final DateTime firstDay = context.select<ProfileDetailModel, DateTime>(
      (model) => model.firstDay,
    );
    final DateTime lastDay = context.select<ProfileDetailModel, DateTime>(
      (model) => model.lastDay,
    );

    return CustomCardBlock(
      title: 'Активность',
      icon: Icons.speed,
      child: SizedBox(
        height: 150,
        child: CustomActivityTable(
          activities: efforts,
          maxValue: maxEff,
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
