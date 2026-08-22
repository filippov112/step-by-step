import 'package:flutter/material.dart';
import 'package:life_game/models/enums/task_difficulty.dart';
import 'package:life_game/screens/tasks/form/task_form_model.dart';
import 'package:provider/provider.dart';

class TaskFormDifficulty extends StatelessWidget {
  const TaskFormDifficulty({super.key});

  @override
  Widget build(BuildContext context) {
    final selectedDifficulty = context.select<TaskFormModel, TaskDifficulty>(
      (model) => model.selectedDifficulty,
    );
    final setDifficulty = context.read<TaskFormModel>().setDifficulty;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Сложность', style: Theme.of(context).textTheme.titleMedium),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: TaskDifficulty.values
              .map(
                (difficulty) => ChoiceChip(
                  label: Text(difficulty.displayName),
                  selected: selectedDifficulty == difficulty,
                  onSelected: (_) => setDifficulty(difficulty),
                ),
              )
              .toList(),
        ),
      ],
    );
  }
}
