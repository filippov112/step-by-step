import 'package:flutter/material.dart';
import 'package:chaos_control/models/enums/achiev_rar.dart';
import 'package:chaos_control/screens/achievements/form/achievement_form_model.dart';
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
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: AchievRar.values
                .map(
                  (rarity) => Padding(
                    padding: EdgeInsetsGeometry.only(right: 8),
                    child: ChoiceChip(
                      label: Text(rarity.displayName),
                      selected: selectedRarity == rarity,
                      onSelected: (_) => setRarity(rarity),
                    ),
                  ),
                )
                .toList(),
          ),
        ),
      ],
    ); //...
  }
}
