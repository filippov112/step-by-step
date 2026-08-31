import 'package:chaos_control/models/enums/wall_status.dart';
import 'package:flutter/material.dart';
import 'package:chaos_control/screens/walls/form/task_form_model.dart';
import 'package:chaos_control/widgets/common/custom_text.dart';
import 'package:provider/provider.dart';

class TaskFormStatus extends StatelessWidget {
  const TaskFormStatus({super.key});

  @override
  Widget build(BuildContext context) {
    final selectedDone = context.select<TaskFormModel, WallStatus>(
      (model) => model.selectedStatus,
    );
    final setDone = context.read<TaskFormModel>().setStatus;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Checkbox(
              value: selectedDone == WallStatus.destroyed,
              onChanged: (val) => setDone(val ?? false),
            ),

            const CustomText('Выполнена'),
          ],
        ),
      ],
    );
  }
}
