import 'package:intl/intl.dart';
import 'package:chaos_control/screens/projects/detail/class_detail_model.dart';
import 'package:chaos_control/services/exp_calculator.dart';

import 'package:flutter/material.dart';
import 'package:chaos_control/widgets/common/custom_text.dart';
import 'package:provider/provider.dart';

class ClassDetailProgress extends StatelessWidget {
  const ClassDetailProgress({super.key});

  @override
  Widget build(BuildContext context) {
    final currentExp = context.select<ClassDetailModel, int>(
      (model) => model.record.experience,
    );
    final currentTime = context.select<ClassDetailModel, int>(
      (model) => model.record.time,
    );

    final int exp = SpiritCalculator.getRemains(currentExp);
    final int expLevel = SpiritCalculator.getLevel(currentExp);
    final int expReq = SpiritCalculator.getRequirements(currentExp);
    final expProgress = (exp / expReq).clamp(0.0, 1.0);

    final int time = SpiritCalculator.getRemains(currentTime);
    final int timeLevel = SpiritCalculator.getLevel(currentTime);
    final int timeReq = SpiritCalculator.getRequirements(currentTime);
    final timeProgress = (time / timeReq).clamp(0.0, 1.0);

    return Column(
      children: [
        CustomText(
          'Экспертность',
          size: 18,
          color: Theme.of(context).colorScheme.onSurface,
          padding: EdgeInsets.fromLTRB(0, 0, 8, 8),
        ),

        Card(
          margin: EdgeInsetsGeometry.all(0),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const CustomText('Накоплено:'),
                    CustomText(
                      '${NumberFormat('#,##0', 'en_US').format(exp)} EXP',
                      weight: FontWeight.bold,
                      expanded: true,
                      padding: EdgeInsets.only(left: 12),
                      align: TextAlign.right,
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const CustomText('Осталось:'),
                    CustomText(
                      '${NumberFormat('#,##0', 'en_US').format(expReq - exp)} EXP',
                      weight: FontWeight.bold,
                      expanded: true,
                      padding: EdgeInsets.only(left: 12),
                      align: TextAlign.right,
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CustomText(
                      '${NumberFormat('#,##0', 'en_US').format(expLevel)} LVL',
                      weight: FontWeight.bold,
                    ),
                    CustomText(
                      '${NumberFormat("#0.00").format(expProgress * 100)}%',
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                LinearProgressIndicator(
                  value: expProgress,
                  minHeight: 8,
                  borderRadius: BorderRadius.all(Radius.circular(4)),
                ),
              ],
            ),
          ),
        ),

        CustomText(
          'Мастерство',
          size: 18,
          color: Theme.of(context).colorScheme.onSurface,
          padding: EdgeInsets.fromLTRB(0, 16, 8, 8),
        ),

        Card(
          margin: EdgeInsetsGeometry.all(0),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const CustomText('Накоплено:'),
                    CustomText(
                      '${NumberFormat('#,##0', 'en_US').format(time)} MIN',
                      weight: FontWeight.bold,
                      expanded: true,
                      padding: EdgeInsets.only(left: 12),
                      align: TextAlign.right,
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const CustomText('Осталось:'),
                    CustomText(
                      '${NumberFormat('#,##0', 'en_US').format(timeReq - time)} MIN',
                      weight: FontWeight.bold,
                      expanded: true,
                      padding: EdgeInsets.only(left: 12),
                      align: TextAlign.right,
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CustomText(
                      '${NumberFormat('#,##0', 'en_US').format(timeLevel)} LVL',
                      weight: FontWeight.bold,
                    ),
                    CustomText(
                      '${NumberFormat("#0.00").format(timeProgress * 100)}%',
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                LinearProgressIndicator(
                  value: timeProgress,
                  minHeight: 8,
                  borderRadius: BorderRadius.all(Radius.circular(4)),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
