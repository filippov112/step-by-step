import 'package:flutter/material.dart';
import 'package:life_game/widgets/common/custom_text.dart';
import 'package:life_game/widgets/common/custom_tile.dart';
import 'package:life_game/widgets/dialogs/select_date_only.dart';

Widget buildDatePicker( 
  BuildContext context,
  { 
    DateTime? currentDatetime, 
    required Function(DateTime?) setDateTime 
  }) {
    return CustomTile(
      callback: () async {
        final result = await selectDateOnly(context, currentDatetime ?? DateTime.now());
        setDateTime(result);
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
              const CustomText('Дата'),
              CustomText(currentDatetime != null ?
                '${currentDatetime.day}.${currentDatetime.month}.${currentDatetime.year}': '',
              ),
            ],
          ),
        ),
        if (currentDatetime != null) 
          IconButton(onPressed: () => setDateTime(null), icon: Icon(Icons.close))
    ]);
}