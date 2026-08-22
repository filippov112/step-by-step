import 'package:flutter/material.dart';
import 'package:life_game/screens/tasks/form/task_form_model.dart';
import 'package:life_game/widgets/common/custom_text.dart';
import 'package:provider/provider.dart';

class TaskFormStatus extends StatelessWidget {
  const TaskFormStatus({super.key});

  @override
  Widget build(BuildContext context) {
    final selectedDone = context.select<TaskFormModel, bool>(
      (model) => model.selectedDone,
    );
    final setDone = context.read<TaskFormModel>().setDone;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Checkbox(
              value: selectedDone,
              onChanged: (val) => setDone(val ?? false),
            ),

            const CustomText('Выполнена'),
          ],
        ),
      ],
    );
  }
}
