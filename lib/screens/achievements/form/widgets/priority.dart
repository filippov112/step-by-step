import 'package:flutter/material.dart';
import 'package:life_game/models/enums/achiev_rar.dart';

Widget buildRaritySelector( 
  BuildContext context,
  { 
    required AchievRar currentRarity, 
    required Function(AchievRar) setRarity 
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Редкость',
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: AchievRar.values.map((rarity) =>
            ChoiceChip(
              label: Text(rarity.displayName),
              selected: currentRarity == rarity,
              onSelected: (_) => setRarity(rarity),
            ),
          ).toList(),
        ),
      ],
    );
}