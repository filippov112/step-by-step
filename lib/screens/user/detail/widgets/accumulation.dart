// ---- Прогресс-бар с иконкой и числом ----
import 'package:flutter/material.dart';
import 'package:life_game/tools/get_age_string.dart';
import 'package:life_game/widgets/analysis/custom_progress_bar.dart';
import 'package:life_game/widgets/analysis/custom_linear_chart.dart';
import 'package:life_game/widgets/common/custom_text.dart';
import 'package:snap_chart/snap_chart.dart';


// Виджет отображения динамики аккумуляции опыта / времени
class AccumulationDynamic extends StatelessWidget {
  
  const AccumulationDynamic({super.key,  
    required this.level, // Уровень 
    required this.title, // Заголовок
    required this.currentValue, // Текущее значение
    required this.nextLevel, // Требование к следующему уровню
    required this.icon, // Иконка
    required this.deltaValue, // Прирост за текущий период 
    required this.oldData, // Значения за ранние периоды
    required this.newData, // Значения за текущий период
    required this.firstDayDelta, // Начало текущего периода
    required this.firstDay, // Начало периода наблюдений
    required this.lastDay, // Окончание периода наблюдений
  });

  final int level;
  final DateTime firstDay;
  final DateTime lastDay;
  final List<SnapSpot> oldData;
  final DateTime firstDayDelta;
  final List<SnapSpot> newData;
  
  final double deltaValue;
  final String title;
  final double currentValue;
  final double nextLevel;
  final IconData icon;


  double getPercent(double val, double max) {
    return max > 0 ? (val / max).clamp(0.0, 1.0) : 0.0;
  }


    @override
  Widget build(BuildContext context) {
    
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Theme.of(context).dividerColor.withAlpha(25),
        borderRadius: const BorderRadius.all(Radius.circular(16)),
        border: Border.all(color: Theme.of(context).dividerColor, width: 1)
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Заголовок
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(icon, size: 32),
              const SizedBox(width: 8),
              CustomText(
                title,
                size: 16,
                color: Theme.of(context).colorScheme.onPrimary,
                expanded: true,
                weight: FontWeight(500),
              ),

              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Theme.of(context).focusColor,
                ),
                child: CustomText(
                  level.toString(), weight: FontWeight.bold, color: Theme.of(context).primaryColor,
                ),
              )
            ],
          ),

          // Числовые значения
          const SizedBox(height: 8),
          Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CustomText('${currentValue.toInt()} / ${nextLevel.toInt()}',
                size: 11, align: TextAlign.center,
              )
              ,
              const SizedBox(width: 8,),
              CustomText('+${deltaValue.toInt()} | ${(getPercent(currentValue, nextLevel) * 100).toInt()}%',
                  size: 11, align: TextAlign.center,
                )
            ],
          ),

          // Прогресс-бар
          const SizedBox(height: 8),
          CustomProgressBar(value: currentValue, maxValue: nextLevel, deltaValue: deltaValue),

          // График роста
          const SizedBox(height: 8),
          Container(
            padding: EdgeInsets.fromLTRB(8,8,8,4),
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.all(Radius.circular(16)),
              border: Border.all(color: Theme.of(context).dividerColor, width: 2)
            ),
            child: Stack(children: [
              CustomLinearChart(
                sortedData: [oldData, newData], 
                minV: firstDay.millisecondsSinceEpoch.toDouble(), 
                maxV: lastDay.millisecondsSinceEpoch.toDouble(),
                colors: [Theme.of(context).focusColor, Colors.orange],
              ),
              Container(
                padding: const EdgeInsets.all(8),
                height: 100, 
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Row(
                      mainAxisSize: MainAxisSize.max,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        CustomText(
                          '${getDateIntervalString(firstDay, lastDay)} / ${getDateIntervalString(firstDayDelta, lastDay)}'
                          , align: TextAlign.end,
                        ),
                    ],
                  ),
                  ],
                )
              ,)
              
            ],)
          ),
        ],
      )
    );
    

  }
}
