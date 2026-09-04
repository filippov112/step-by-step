import 'package:flutter/material.dart';
import 'package:chaos_control/models/enums/wall_difficulty.dart';
import 'package:chaos_control/screens/walls/edit/wall_edit_model.dart';
import 'package:provider/provider.dart';

class WallCreateDifficulty extends StatelessWidget {
  const WallCreateDifficulty({super.key});

  @override
  Widget build(BuildContext context) {
    final selectedDifficulty = context.select<WallEditModel, WallDiff>(
      (model) => model.difficulty,
    );
    final setDifficulty = context.read<WallEditModel>().setDifficulty;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Сложность', style: Theme.of(context).textTheme.titleMedium),
        const SizedBox(height: 8),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: WallDiff.values
                .map(
                  (difficulty) => Padding(
                    padding: EdgeInsetsGeometry.only(right: 8),
                    child: ChoiceChip(
                      label: Text(difficulty.name),
                      selected: selectedDifficulty == difficulty,
                      onSelected: (_) => setDifficulty(difficulty),
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
