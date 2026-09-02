import 'package:flutter/material.dart';
import 'package:chaos_control/screens/walls/list/wall_list_model.dart';
import 'package:chaos_control/tools/format_date.dart';
import 'package:chaos_control/widgets/common/custom_text.dart';
import 'package:provider/provider.dart';

class TaskListDate extends StatelessWidget {
  final DateTime? selectedDate;
  final Function(DateTime) selectDate;

  const TaskListDate({
    super.key,
    required this.selectDate,
    required this.selectedDate,
  });

  @override
  Widget build(BuildContext context) {
    final dateFilter = context.select<WallListModel,WallDateFilterType>((model) => model.dateFilter);
    final current = selectedDate ?? DateTime.now();
    final datePre1 = current.subtract(const Duration(days: 1));
    final datePre2 = current.subtract(const Duration(days: 2));

    final datePost1 = current.add(const Duration(days: 1));
    final datePost2 = current.add(const Duration(days: 2));

    return dateFilter == WallDateFilterType.date ?
    Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        TaskListDateButton(onTap: () => selectDate(datePre2), day: datePre2),

        TaskListDateButton(onTap: () => selectDate(datePre1), day: datePre1),

        TaskListDateButton(
          onTap: () => selectDate(current),
          day: current,
          isCurrent: true,
        ),

        TaskListDateButton(onTap: () => selectDate(datePost1), day: datePost1),

        TaskListDateButton(onTap: () => selectDate(datePost2), day: datePost2),
      ],
    ) : SizedBox();
  }
}

class TaskListDateButton extends StatelessWidget {
  final bool isCurrent;
  final DateTime day;
  final VoidCallback onTap;

  const TaskListDateButton({
    super.key,
    this.isCurrent = false,
    required this.day,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final size = isCurrent ? 50.0 : 35.0;
    final now = DateTime(
      DateTime.now().year,
      DateTime.now().month,
      DateTime.now().day,
    );

    final button = Container(
      width: size,
      height: size,
      padding: EdgeInsets.all(4),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: now == day ? Theme.of(context).focusColor.withAlpha(120) : null,
        border: Border.all(color: Theme.of(context).dividerColor, width: 3),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CustomText(day.day.toString(), size: 12, color: Colors.white),
          if (isCurrent)
            CustomText(
              getShortMonthName(day.month),
              size: 9,
              color: Colors.white,
            ),
        ],
      ),
    );

    return isCurrent
        ? button
        : SizedBox(
            width: size,
            height: size,
            child: OutlinedButton(
              style: OutlinedButton.styleFrom(
                side: BorderSide(
                  color: Theme.of(context).focusColor,
                  width: 1.5,
                ),
                shape: CircleBorder(),
                padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
              ),
              onPressed: onTap,
              child: button,
            ),
          );
  }
}
