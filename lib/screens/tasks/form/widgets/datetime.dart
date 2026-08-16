import 'package:flutter/material.dart';
import 'package:life_game/widgets/common/custom_text.dart';
import 'package:life_game/widgets/common/custom_tile.dart';
import 'package:life_game/widgets/dialogs/select_date_time.dart';

Widget buildDateTimePicker( 
  BuildContext context,
  { 
    DateTime? currentDatetime, 
    required Function(DateTime?) setDateTime 
  }) {
    return CustomTile(
      callback: () async {
        final result = await selectDateTime(context, currentDatetime ?? DateTime.now());
        if (result != null) {
          setDateTime(result);
        }
      },
      padding: 16,
      borderRadius: 16,
      children: [
        const Icon(Icons.event),
        const SizedBox(width: 16,),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const CustomText('Дата и время'),
              CustomText(currentDatetime != null ?
                '${currentDatetime.day}.${currentDatetime.month}.${currentDatetime.year} '
                '${currentDatetime.hour}:${currentDatetime.minute.toString().padLeft(2, '0')}' : '',
              ),
            ],
          ),
        ),
        if (currentDatetime != null) 
          IconButton(onPressed: () => setDateTime(null), icon: Icon(Icons.close))
    ]);
}