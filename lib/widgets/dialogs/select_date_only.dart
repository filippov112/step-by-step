import 'package:flutter/material.dart';

// Диалог выбора даты
Future<DateTime> selectDateOnly(BuildContext context, DateTime initDate) async {
  // 1. Выбор даты
  final date = await showDatePicker(
    context: context,
    initialDate: initDate,
    firstDate: DateTime(1900),
    lastDate: DateTime(2100),
  );
  if (date == null) {
    return initDate;
  }
  initDate = DateTime(
    date.year,
    date.month,
    date.day,
  );
  return initDate;
}