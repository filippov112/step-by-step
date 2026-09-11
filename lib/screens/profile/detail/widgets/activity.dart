import 'package:chaos_control/models/enums/characteristics.dart';
import 'package:chaos_control/services/analytics/dto_activity.dart';
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

enum ActivityType {
  all,
  control,
  perseverance,
  courage,
  durability,
  creativity,
}

extension ActivityTypeExt on ActivityType {
  Characteristic? get characteristic {
    switch (this) {
      case ActivityType.control:
        return Characteristic.control;
      case ActivityType.perseverance:
        return Characteristic.perseverance;
      case ActivityType.courage:
        return Characteristic.courage;
      case ActivityType.durability:
        return Characteristic.durability;
      case ActivityType.creativity:
        return Characteristic.creativity;
      default:
        return null;
    }
  }

  IconData get icon {
    return characteristic?.icon ?? Icons.bar_chart;
  }
}

class _ProfileDetailActivityState extends State<ProfileDetailActivity> {
  ActivityType typeFilter = ActivityType.all;

  @override
  Widget build(BuildContext context) {
    final Map<DateTime, DtoActivity> efforts = context
        .select<ProfileDetailModel, Map<DateTime, DtoActivity>>(
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

    final focusColor = Theme.of(context).focusColor;
    final disabledColor = Theme.of(context).disabledColor;

    final table = CustomActivityTable(
      activities: efforts.map(
        (k, v) => MapEntry(k, v.getChar(typeFilter.characteristic)),
      ),
      maxValue: maxEff,
      minColor: typeFilter.characteristic?.color.withAlpha(30),
      maxColor: typeFilter.characteristic?.color,
      startDate: firstDay,
      endDate: lastDay,
      cellSpacing: 3,
      showMonthLabels: true,
      showWeekLabels: true,
    );

    final buttons = Padding(
      padding: const EdgeInsetsGeometry.only(top: 12),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: ActivityType.values.map((type) {
            final color = typeFilter == type
                ? type.characteristic?.color ?? focusColor
                : disabledColor;
            return IconButton(
              icon: Icon(type.icon, color: color),
              onPressed: () => setState(() {
                typeFilter = type;
              }),
            );
          }).toList(),
        ),
      ),
    );

    return CustomCardBlock(
      title: 'Активность',
      icon: Icons.speed,
      child: SizedBox(
        height: 200,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(child: table),
            buttons,
          ],
        ),
      ),
    );
  }
}
