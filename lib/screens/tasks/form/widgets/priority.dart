import 'package:flutter/material.dart';
import 'package:life_game/models/enums/task_priority.dart';

Widget buildPrioritySelector( 
  BuildContext context,
  { 
    required TaskPriority currentPriority, 
    required Function(TaskPriority) setPriority 
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Приоритет',
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: TaskPriority.values.map((priority) =>
            ChoiceChip(
              label: Text(priority.displayName),
              selected: currentPriority == priority,
              onSelected: (_) => setPriority(priority),
            ),
          ).toList(),
        ),
      ],
    );
}