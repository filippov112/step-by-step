import 'package:flutter/material.dart';
import 'package:life_game/widgets/common/custom_text.dart';

class ActivityGrid extends StatelessWidget {
  final Map<DateTime, int> activities; // Дата -> количество задач
  final DateTime startDate;
  final DateTime endDate;
  final double cellSpacing;
  final Color emptyColor;
  final List<Color> levelColors;
  final void Function(DateTime date, int count)? onCellTap;
  final bool showWeekLabels;
  final bool showMonthLabels;

  const ActivityGrid({
    super.key,
    required this.activities,
    required this.startDate,
    required this.endDate,
    this.cellSpacing = 4,
    this.emptyColor = const Color(0xFFEBEDF0),
    this.levelColors = const [
      Color(0xFFEBEDF0), // 0
      Color(0xFF9BE9A8), // 1-3
      Color(0xFF40C463), // 4-6
      Color(0xFF30A14E), // 7-9
      Color(0xFF216E39), // 10+
    ],
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
    var current = DateTime(start.year, start.month, start.day);
    final endDate = DateTime(end.year, end.month, end.day);
    
    while (current.isBefore(endDate) || current.isAtSameMomentAs(endDate)) {
      days.add(current);
      current = current.add(const Duration(days: 1));
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
    
    return weeks.map((week) {
          return Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [ 
                ...week.map((day) {
                  final isRealDay = day.year >= 2020;
                  final count = isRealDay ? (activities[day] ?? 0) : 0;
                  final color = _getColorForCount(count);
                
                  return Expanded(child:
                    GestureDetector(
                      onTap: isRealDay && onCellTap != null
                          ? () => onCellTap!(day, count)
                          : null,
                      child: Container(
                        margin: EdgeInsets.only(right: cellSpacing, bottom: cellSpacing),
                        decoration: BoxDecoration(
                          color: isRealDay ? color : Colors.transparent,
                          borderRadius: BorderRadius.circular(2),
                          border: Border.all(
                            color: isRealDay ? Theme.of(context).dividerColor : Colors.transparent,
                            width: 1,
                          ),
                        ),
                        child: isRealDay && count > 0
                            ? Tooltip(
                                message: '$count задач - ${_formatDate(day)}',
                                child: Container(),
                              )
                            : null,
                      ),
                    )
                  );
                }),

                if (week.length < 7) Expanded(flex: 7 - week.length, child: SizedBox(),),

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

  /// Определяем цвет по количеству задач
  Color _getColorForCount(int count) {
    if (count == 0) return emptyColor;
    if (count <= 3) return levelColors[1];
    if (count <= 6) return levelColors[2];
    if (count <= 9) return levelColors[3];
    return levelColors[4];
  }

  String _formatDate(DateTime date) {
    return '${date.day}.${date.month}.${date.year}';
  }
}