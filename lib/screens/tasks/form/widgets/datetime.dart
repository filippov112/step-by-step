import 'package:flutter/material.dart';
import 'package:life_game/widgets/dialogs/select_date_time.dart';
import 'package:path/path.dart';

Widget buildDateTimePicker( 
  BuildContext context,
  { 
    DateTime? currentDatetime, 
    required Function(DateTime?) setDateTime 
  }) {
    return Card(
      margin: EdgeInsets.all(0),
      child: ListTile(
        leading: const Icon(Icons.event),
        title: Text('Дата и время'),
        subtitle: Text(currentDatetime != null ?
          '${currentDatetime.day}.${currentDatetime.month}.${currentDatetime.year} '
          '${currentDatetime.hour}:${currentDatetime.minute.toString().padLeft(2, '0')}' : '',
        ),
        onTap: () async {
          final result = await selectDateTime(context, currentDatetime ?? DateTime.now());
          if (result != null) {
            setDateTime(result);
          }
        },
      ),
    );
}