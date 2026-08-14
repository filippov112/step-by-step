import 'package:flutter/material.dart';
import 'package:life_game/models/enums/task_difficulty.dart';

Widget buildDifficultySelector(
  BuildContext context, 
  {
    required TaskDifficulty currentDifficulty, 
    required Function(TaskDifficulty) setDifficulty
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Сложность',
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: TaskDifficulty.values.map((difficulty) =>
            ChoiceChip(
              label: Text(difficulty.displayName),
              selected: currentDifficulty == difficulty,
              onSelected: (_) => setDifficulty(difficulty),
           ),
          ).toList(),
        ),
      ],
    );
}