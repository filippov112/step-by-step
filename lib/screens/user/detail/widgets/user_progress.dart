import 'package:flutter/material.dart';
import 'package:life_game/widgets/analysis/custom_progress_bar.dart';
import 'package:life_game/widgets/analysis/custom_linear_chart.dart';
import 'package:life_game/widgets/common/custom_card_block.dart';
import 'package:life_game/widgets/common/custom_text.dart';
import 'package:snap_chart/snap_chart.dart';

// Виджет отображения динамики аккумуляции опыта / времени
class UserProgress extends StatefulWidget {
  final int level;
  final DateTime firstDay;
  final DateTime lastDay;
  final List<SnapSpot> data;

  final double deltaValue;
  final String title;
  final double currentValue;
  final double nextLevel;
  final IconData icon;

  const UserProgress({
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
  State<UserProgress> createState() => _UserProgressState();
}

class _UserProgressState extends State<UserProgress> {
  bool isExpanded = false;

  double getPercent(double val, double max) {
    return max > 0 ? (val / max).clamp(0.0, 1.0) : 0.0;
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
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Theme.of(context).focusColor,
            ),
            child: CustomText(
              widget.level.toString(),
              weight: FontWeight.bold,
              color: Theme.of(context).primaryColor,
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
                '${widget.currentValue.toInt()} / ${widget.nextLevel.toInt()}',
                size: 11,
                align: TextAlign.center,
              ),
              const SizedBox(width: 8),
              CustomText(
                '+${widget.deltaValue.toInt()} | ${(getPercent(widget.currentValue, widget.nextLevel) * 100).toInt()}%',
                size: 11,
                align: TextAlign.center,
              ),
            ],
          ),

          // Прогресс-бар
          const SizedBox(height: 8),
          CustomProgressBar(
            value: widget.currentValue,
            maxValue: widget.nextLevel,
            deltaValue: widget.deltaValue,
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
                minV: widget.firstDay.millisecondsSinceEpoch.toDouble(),
                maxV: widget.lastDay.millisecondsSinceEpoch.toDouble(),
                colors: [Theme.of(context).focusColor],
              ),
            ),
          },
        ],
      ),
    );
  }
}
