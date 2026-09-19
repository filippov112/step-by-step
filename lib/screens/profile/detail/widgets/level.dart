import 'package:chaos_control/screens/profile/detail/profile_detail_model.dart';
import 'package:chaos_control/services/numerictool.dart';
import 'package:chaos_control/services/hours_calculator.dart';
import 'package:chaos_control/widgets/screens/loading_screen.dart';
import 'package:flutter/material.dart';
import 'package:chaos_control/services/datetool.dart';
import 'package:chaos_control/widgets/analysis/custom_progress_bar.dart';
import 'package:chaos_control/widgets/analysis/custom_linear_chart.dart';
import 'package:chaos_control/widgets/common/custom_card_block.dart';
import 'package:chaos_control/widgets/common/custom_text.dart';
import 'package:provider/provider.dart';
import 'package:snap_chart/snap_chart.dart';

// Виджет отображения уровня
class ProfileDetailLevel extends StatefulWidget {
  const ProfileDetailLevel({
    super.key,
  });

  @override
  State<ProfileDetailLevel> createState() => _ProfileDetailLevelState();
}

class _ProfileDetailLevelState extends State<ProfileDetailLevel> {
  bool isExpanded = false;

  double getPercent(int val, int max) {
    return max > 0 ? (val.toDouble() / max).clamp(0.0, 1.0) : 0.0;
  }

  @override
  Widget build(BuildContext context) {

    final deltaColor = Colors.amber;

    final calculator = context.read<HoursCalculator>();
    final hours = context.select<ProfileDetailModel, int>((model) => model.user?.hours ?? 0);

    final int deltaHours = context.select<ProfileDetailModel, int>(
      (model) => model.deltaHours,
    );
    final DateTime firstDay = context.select<ProfileDetailModel, DateTime>(
      (model) => model.firstDay,
    );
    final DateTime lastDay = context.select<ProfileDetailModel, DateTime>(
      (model) => model.lastDay,
    );
    final List<SnapSpot> progressData = context
        .select<ProfileDetailModel, List<SnapSpot>>(
          (model) => model.graphData,
        );
    final isLoading = context.select<ProfileDetailModel, bool>((m) => m.isLoading);
    final loadingScreen = const CustomLoadingScreen();

    return CustomCardBlock(
      icon: Icons.local_fire_department,
      iconColor: deltaColor,
      title: 'Уровень',
      trailing: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Развернуть граф
          Padding(
            padding: EdgeInsetsGeometry.symmetric(horizontal: 8),
            child: IconButton(
              color: isExpanded
                  ? Theme.of(context).focusColor
                  : Theme.of(context).dividerColor,
              onPressed: () => setState(() => isExpanded = !isExpanded),
              icon: Icon(Icons.auto_graph),
            ),
          ),

          // Уровень
          if(!isLoading) Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
            decoration: BoxDecoration(
              shape: BoxShape.rectangle,
              boxShadow: [ BoxShadow(blurStyle: BlurStyle.outer, color: deltaColor, blurRadius: 12),],
              border: Border.all(width: 2, color: deltaColor),
              borderRadius: const BorderRadius.all(Radius.circular(8))
            ),
            child: CustomText(
              NumericTool.toThousandString(calculator.getLevel(hours)),
              weight: FontWeight.bold,
              color: deltaColor,
              shadow: Shadow(color: deltaColor, blurRadius: 6),
            ),
          ),
        ],
      ),
      child: isLoading ? loadingScreen : Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Числовые значения
          Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CustomText(
                '${NumericTool.toThousandString(calculator.getLevelRemains(hours))} / ${NumericTool.toThousandString(calculator.getLevelRequirements(hours))} h.',
                size: 11,
                align: TextAlign.center,
              ),
              const SizedBox(width: 8),
              CustomText(
                '+${NumericTool.toThousandString(deltaHours)} h. | ${(getPercent(calculator.getLevelRemains(hours), calculator.getLevelRequirements(hours)) * 100).round()}%',
                size: 11,
                align: TextAlign.center,
              ),
            ],
          ),

          // Прогресс-бар
          const SizedBox(height: 8),
          CustomProgressBar(
            value: calculator.getLevelRemains(hours).toDouble(),
            maxValue: calculator.getLevelRequirements(hours).toDouble(),
            deltaValue: deltaHours.toDouble(),
          ),

          // График роста
          if (isExpanded) ...{
            const SizedBox(height: 8),
            Container(
              padding: EdgeInsets.fromLTRB(8, 8, 8, 4),
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.all(Radius.circular(16)),
                border: Border.all(
                  color: Theme.of(context).dividerColor,
                  width: 2,
                ),
              ),
              child: CustomLinearChart(
                sortedData: [progressData],
                minV: (DateTool.datetimeToDays(firstDay) ?? 0).toDouble(),
                maxV: (DateTool.datetimeToDays(lastDay) ?? 0).toDouble(),
                colors: [Theme.of(context).focusColor],
              ),
            ),
          },
        ],
      ),
    );
  }
}
