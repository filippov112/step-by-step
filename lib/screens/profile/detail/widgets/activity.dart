import 'dart:math';
import 'dart:ui';

import 'package:chaos_control/models/enums/characteristics_ext.dart';
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

class _ProfileDetailActivityState extends State<ProfileDetailActivity> {
  CharacteristicExt typeFilter = CharacteristicExt.all;
  int pageIndex = 0;

  void changePage(int delta) {
    setState(() {
      pageIndex = clampDouble((pageIndex + delta).toDouble(), 0, 3).round();
    });
  }

  @override
  Widget build(BuildContext context) {
    final efforts = context
        .select<ProfileDetailModel, Map<DateTime, DtoActivity>>(
          (model) => model.activityData,
        );
    final maxEff = context.select<ProfileDetailModel, int>(
      (model) => model.maxSF,
    );
    final firstDay = context.select<ProfileDetailModel, DateTime>(
      (model) => model.firstDay,
    );
    final lastDay = context.select<ProfileDetailModel, DateTime>(
      (model) => model.lastDay,
    );
    final periodType = context.select<ProfileDetailModel, PeriodFilterType>(
      (m) => m.periodFilter,
    );

    final focusColor = Theme.of(context).focusColor;
    final disabledColor = Theme.of(context).disabledColor;
    final dividerColor = Theme.of(context).dividerColor;

    final table = CustomActivityTable(
      activities: efforts.map(
        (k, v) => MapEntry(k, v.getChar(typeFilter.characteristic)),
      ),
      maxValue: maxEff,
      minColor: typeFilter.characteristic?.color.withAlpha(30),
      maxColor: typeFilter.characteristic?.color,
      startDate: periodType == PeriodFilterType.year
          ? DateTime.fromMillisecondsSinceEpoch(
              max<int>(
                firstDay.millisecondsSinceEpoch,
                firstDay
                    .add(Duration(days: 92 * pageIndex))
                    .millisecondsSinceEpoch,
              ),
            )
          : firstDay,
      endDate: periodType == PeriodFilterType.year
          ? DateTime.fromMillisecondsSinceEpoch(
              min<int>(
                lastDay.millisecondsSinceEpoch,
                firstDay
                    .add(Duration(days: 92 * (pageIndex + 1)))
                    .millisecondsSinceEpoch,
              ),
            )
          : lastDay,
      cellSpacing: 3,
      showMonthLabels: true,
      showWeekLabels: true,
    );

    final pageButtons = periodType == PeriodFilterType.year
        ? Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              IconButton(
                icon: Icon(Icons.arrow_left),
                color: pageIndex == 0 ? disabledColor : focusColor,
                onPressed: () => changePage(-1),
              ),
              IconButton(
                icon: Icon(Icons.arrow_right),
                color: pageIndex == 3 ? disabledColor : focusColor,
                onPressed: () => changePage(1),
              ),
            ],
          )
        : null;

    final charButtons = Padding(
      padding: const EdgeInsetsGeometry.only(top: 12),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: CharacteristicExt.values.map((type) {
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
        height: periodType == PeriodFilterType.year ? 250 : 200,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  border: Border.all(color: dividerColor, width: 1)
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Expanded(child: table),
                    ?pageButtons,
                  ],
                ),
              ),
            ),

            charButtons,
          ],
        ),
      ),
    );
  }
}
