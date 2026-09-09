import 'package:chaos_control/services/numerictool.dart';
import 'package:flutter/material.dart';
import 'package:chaos_control/services/datetool.dart';
import 'package:chaos_control/widgets/analysis/custom_progress_bar.dart';
import 'package:chaos_control/widgets/analysis/custom_linear_chart.dart';
import 'package:chaos_control/widgets/common/custom_card_block.dart';
import 'package:chaos_control/widgets/common/custom_text.dart';
import 'package:snap_chart/snap_chart.dart';

// Виджет отображения динамики аккумуляции опыта / времени
class ProfileProgress extends StatefulWidget {
  final int level;
  final DateTime firstDay;
  final DateTime lastDay;
  final List<SnapSpot> data;

  final int deltaValue;
  final String title;
  final int currentValue;
  final int nextLevel;
  final IconData icon;

  const ProfileProgress({
    super.key,
    required this.level, // Уровень
    required this.title, // Заголовок
    required this.currentValue, // Текущее значение
    required this.nextLevel, // Требование к следующему уровню
    required this.icon, // Иконка
    required this.deltaValue, // Прирост за текущий период
    required this.data, // Значения
    required this.firstDay, // Начало периода наблюдений
    required this.lastDay, // Окончание периода наблюдений
  });

  @override
  State<ProfileProgress> createState() => _ProfileProgressState();
}

class _ProfileProgressState extends State<ProfileProgress> {
  bool isExpanded = false;

  double getPercent(int val, int max) {
    return max > 0 ? (val.toDouble() / max).clamp(0.0, 1.0) : 0.0;
  }

  @override
  Widget build(BuildContext context) {
    return CustomCardBlock(
      icon: widget.icon,
      title: widget.title,
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
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
            decoration: BoxDecoration(
              shape: BoxShape.rectangle,
              boxShadow: [ const BoxShadow(blurStyle: BlurStyle.outer, color: Colors.amber, blurRadius: 12),],
              border: Border.all(width: 2, color: Colors.amber),
              borderRadius: const BorderRadius.all(Radius.circular(8))
            ),
            child: CustomText(
              NumericTool.toThousandString(widget.level),
              weight: FontWeight.bold,
              color: Colors.amber,
              shadow: const Shadow(color: Colors.amber, blurRadius: 6),
            ),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Числовые значения
          Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CustomText(
                '${NumericTool.toThousandString(widget.currentValue)} / ${NumericTool.toThousandString(widget.nextLevel)} SF',
                size: 11,
                align: TextAlign.center,
              ),
              const SizedBox(width: 8),
              CustomText(
                '+${NumericTool.toThousandString(widget.deltaValue)} SF | ${(getPercent(widget.currentValue, widget.nextLevel) * 100).round()}%',
                size: 11,
                align: TextAlign.center,
              ),
            ],
          ),

          // Прогресс-бар
          const SizedBox(height: 8),
          CustomProgressBar(
            value: widget.currentValue.toDouble(),
            maxValue: widget.nextLevel.toDouble(),
            deltaValue: widget.deltaValue.toDouble(),
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
                sortedData: [widget.data],
                minV: (DateTool.datetimeToDays(widget.firstDay) ?? 0).toDouble(),
                maxV: (DateTool.datetimeToDays(widget.lastDay) ?? 0).toDouble(),
                colors: [Theme.of(context).focusColor],
              ),
            ),
          },
        ],
      ),
    );
  }
}
