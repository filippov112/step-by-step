import 'package:flutter/material.dart';
import 'package:chaos_control/screens/tasks/form/task_form_model.dart';
import 'package:chaos_control/widgets/form/datetime_picker.dart';
import 'package:provider/provider.dart';

class TaskFormDatetime extends StatelessWidget {
  const TaskFormDatetime({super.key});

  @override
  Widget build(BuildContext context) {
    final selectedDatetime = context.select<TaskFormModel, DateTime?>(
      (model) => model.selectedDateTime,
    );
    final setDateTime = context.read<TaskFormModel>().setDateTime;

    return CustomDateTime(callback: setDateTime, value: selectedDatetime, title: 'Дедлайн');
  }
}
