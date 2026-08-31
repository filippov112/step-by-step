import 'package:flutter/material.dart';
import 'package:chaos_control/models/enums/wall_priority.dart';
import 'package:chaos_control/screens/walls/form/task_form_model.dart';
import 'package:provider/provider.dart';

class TaskFormPriority extends StatelessWidget {
  const TaskFormPriority({super.key});

  @override
  Widget build(BuildContext context) {
    final selectedPriority = context.select<TaskFormModel, WallPriority>(
      (model) => model.selectedPriority,
    );
    final setPriority = context.read<TaskFormModel>().setPriority;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Приоритет', style: Theme.of(context).textTheme.titleMedium),
        const SizedBox(height: 8),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: WallPriority.values
                .map(
                  (priority) => Padding(
                    padding: EdgeInsetsGeometry.only(right: 8),
                    child: ChoiceChip(
                      label: Text(priority.displayName),
                      selected: selectedPriority == priority,
                      onSelected: (_) => setPriority(priority),
                    ),
                  ),
                )
                .toList(),
          ),
        ),
      ],
    );
  }
}
