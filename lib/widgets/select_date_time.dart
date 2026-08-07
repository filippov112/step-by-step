import 'package:flutter/material.dart';

Future<DateTime?> selectDateTime(BuildContext context, DateTime dateTime) async {
  // 1. Выбор даты
  final date = await showDatePicker(
    context: context,
    initialDate: dateTime,
    firstDate: DateTime(1900),
    lastDate: DateTime(2100),
  );
  if (date == null) return dateTime;
  final time = await showTimePicker(
    context: context,
    initialTime: TimeOfDay.fromDateTime(dateTime),
  );
  if (time == null) {
    return DateTime(date.year, date.month, date.day);
  }
  return DateTime(
    date.year,
    date.month,
    date.day,
    time.hour,
    time.minute,
  );
}