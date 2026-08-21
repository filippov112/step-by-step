import 'package:flutter/material.dart';
import 'package:life_game/models/enums/achiev_rar.dart';
import 'package:life_game/screens/achievements/form/achievement_form_model.dart';
import 'package:provider/provider.dart';

class AchievFormRarity extends StatelessWidget {
  const AchievFormRarity({super.key});

  @override
  Widget build(BuildContext context) {
    final model = context.read<AchievementFormModel>();
    final selectedRarity = context.select<AchievementFormModel, AchievRar>(
      (model) => model.selectedRarity,
    );

    final setRarity = model.setRarity;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Редкость', style: Theme.of(context).textTheme.titleMedium),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: AchievRar.values
              .map(
                (rarity) => ChoiceChip(
                  label: Text(rarity.displayName),
                  selected: selectedRarity == rarity,
                  onSelected: (_) => setRarity(rarity),
                ),
              )
              .toList(),
        ),
      ],
    ); //...
  }
}
