import 'package:flutter/material.dart';
import 'package:life_game/widgets/common/custom_text.dart';
import 'package:life_game/widgets/common/custom_tile.dart';
import 'package:life_game/widgets/dialogs/select_date_only.dart';
import 'package:life_game/widgets/dialogs/select_date_time.dart';

class CustomDateTime extends StatelessWidget {
  final DateTime? value;
  final Function(DateTime?) callback;
  final bool dateOnly;
  final String? title;

  const CustomDateTime({
    super.key,
    required this.callback,
    required this.value,
    this.dateOnly = false,
    this.title,
  });

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final displayValue = value != null
        ? (dateOnly
              ? '${value!.day}.${value!.month}.${value!.year} '
              : '${value!.day}.${value!.month}.${value!.year} '
                    '${value!.hour}:${value!.minute.toString().padLeft(2, '0')}')
        : '';

    return CustomTile(
      callback: () async {
        final result = dateOnly
            ? await selectDateOnly(
                context,
                value ?? DateTime(now.year, now.month, now.day),
              )
            : await selectDateTime(
                context,
                value ??
                    DateTime(
                      now.year,
                      now.month,
                      now.day,
                      now.hour,
                      now.minute,
                    ),
              );
        if (result != null) {
          callback(result);
        }
      },
      padding: 16,
      borderRadius: 16,
      children: [
        const Icon(Icons.event),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomText(title ?? (dateOnly ? 'Дата' : 'Дата и время')),
              CustomText(displayValue),
            ],
          ),
        ),
        if (value != null)
          IconButton(onPressed: () => callback(null), icon: Icon(Icons.close)),
      ],
    );
  }
}
