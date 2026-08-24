import 'package:flutter/material.dart';
import 'package:life_game/models/enums/task_priority.dart';
import 'package:life_game/screens/tasks/form/task_form_model.dart';
import 'package:provider/provider.dart';

class TaskFormPriority extends StatelessWidget {
  const TaskFormPriority({super.key});

  @override
  Widget build(BuildContext context) {
    final selectedPriority = context.select<TaskFormModel, TaskPriority>(
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
            children: TaskPriority.values
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
