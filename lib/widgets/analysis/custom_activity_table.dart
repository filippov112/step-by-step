import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:life_game/tools/datetime.dart';
import 'package:life_game/widgets/common/custom_text.dart';


// Виджет активности за период
class CustomActivityTable extends StatelessWidget {
  final Map<DateTime, int> activities; // Набор данных
  final DateTime startDate; // Начало периода
  final DateTime endDate; // Конец периода
  final double cellSpacing; // Промежутки между ячейками
  final Color? minColor; // Минимальный цвет
  final Color? maxColor; // Максимальный цвет
  final int maxValue; // Верхняя граница значений
  final void Function(DateTime date)? onCellTap; // Колбек при нажатии на ячейку
  final bool showWeekLabels; // Отображать дни недели
  final bool showMonthLabels; // Отображать месяца

  const CustomActivityTable({
    super.key,
    required this.activities,
    required this.startDate,
    required this.endDate,
    this.cellSpacing = 4,
    this.minColor,
    this.maxColor,
    required this.maxValue,
    this.onCellTap,
    this.showWeekLabels = true,
    this.showMonthLabels = true,
  });

  @override
  Widget build(BuildContext context) {
    final days = _getDaysInRange(startDate, endDate);
    final weeks = _groupDaysByWeek(days);

    return Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Боковые подписи (дни недели)
          if (showWeekLabels) _buildWeekLabels(),
          const SizedBox(width: 8),
          // Основная сетка
          ..._buildGrid(context, weeks),
        ],
      );
  }

  /// Получаем все дни в диапазоне
  List<DateTime> _getDaysInRange(DateTime start, DateTime end) {
    final days = <DateTime>[];
    int current = DateTool.datetimeToDays(start) ?? 0;
    int endDate = DateTool.datetimeToDays(end) ?? 0;
    
    while (current < endDate || current == endDate) {
      final day = DateTool.joinDateTime(date: current);
      current++;
      if (day == null) continue;
      days.add(day);
    }
    return days;
  }

  /// Группируем дни по неделям
  List<List<DateTime>> _groupDaysByWeek(List<DateTime> days) {
    var currentWeek = <DateTime>[];
    final weeks = <List<DateTime>>[currentWeek];
    if (days.isEmpty) return weeks;

    DateTime firstDay = days.first;

    // Добавляем пустые дни после воскресенья
    for (int i = 1; i < firstDay.weekday; i++) {
      currentWeek.add(DateTime(firstDay.year, firstDay.month, firstDay.day - firstDay.weekday + i));
    }
    
    for (final day in days) {
      // Начинаем новую неделю с понедельника
      if (day.weekday == DateTime.monday && currentWeek.isNotEmpty) {
        currentWeek = [];
        weeks.add(currentWeek);
      }
      currentWeek.add(day);
    }
    return weeks;
  }

  /// Виджет подписей дней недели
  Widget _buildWeekLabels() {
    const weekdays = ['Пн', 'Вт', 'Ср', 'Чт', 'Пт', 'Сб', 'Вс'];
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      mainAxisSize: MainAxisSize.max,
      children: [ 
        ...weekdays.map((day) {
          return Expanded(child: 
            Container(
              alignment: Alignment.centerLeft,
              margin: EdgeInsets.only(right: cellSpacing, bottom: cellSpacing),
              padding: const EdgeInsets.only(right: 2),
              child: CustomText(day, size: 10),
            )
          );
        }),
        if (showMonthLabels)
          Expanded(child: 
            Container(
              alignment: Alignment.centerLeft,
              margin: EdgeInsets.only(right: cellSpacing, bottom: cellSpacing),
              padding: const EdgeInsets.only(right: 2),
              child: SizedBox()
            )
          ),
      ]
    );
  }

  final months = const ['Ян', 'Фв', 'Мр', 'Ап', 'Мй', 'Ин', 'Ил', 'Ав', 'Сн', 'Ок', 'Нб', 'Дк'];

  /// Основная сетка
  List<Widget> _buildGrid(BuildContext context, List<List<DateTime>> weeks) {
    
    var minC = minColor ?? Theme.of(context).dividerColor;
    var maxC = maxColor ?? Theme.of(context).focusColor;

    final startDateDays = DateTool.datetimeToDays(startDate) ?? 0;
    final endDateDays = DateTool.datetimeToDays(endDate) ?? 0;
    
    return weeks.map((week) {
          return Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [ 
                ...week.map((day) {
                  final dayDays = DateTool.datetimeToDays(day) ?? 0;
                  final isRealDay = 
                    dayDays >= startDateDays && 
                    dayDays <= endDateDays;
                  final val = isRealDay ? (activities[day] ?? 0) : 0;
                  final color = _getColorForCount(minC, maxC, val);
              
                  return Expanded(
                    child: Container(
                      margin: EdgeInsets.only(right: cellSpacing, bottom: cellSpacing),
                      decoration: BoxDecoration(
                        color: isRealDay ? color : minC.withValues(alpha: 0.2),
                      ),
                    )
                  );
                }),

                if (week.length < 7) Expanded(flex: 7 - week.length, child: SizedBox(),),

                if (showMonthLabels)
                  Expanded(child: Text(getBeginMonth(week)),)
              ]
            )
          );
        }).toList();
  }

  String getBeginMonth(List<DateTime> week) {
    var day = week.firstWhere((d) => d.day == 1, orElse: () => DateTime(0));
    if (day == DateTime(0)) return '';
    return months[day.month - 1];
  }

  /// Определяем цвет
  Color _getColorForCount(Color minC, Color maxV, int v) {
    var t = maxValue == 0 || maxValue < v ? 0.0 : v.toDouble() / maxValue;
    return Color.from(
      alpha: 1, 
      red: lerpDouble(minC.r, maxV.r, t) ?? 0, 
      green: lerpDouble(minC.g, maxV.g, t) ?? 0, 
      blue: lerpDouble(minC.b, maxV.b, t) ?? 0
    );
  }
}