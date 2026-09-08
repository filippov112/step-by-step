import 'package:flutter/material.dart';
import 'package:chaos_control/models/enums/purport_type.dart';
import 'package:chaos_control/screens/purports/form/purport_form_model.dart';
import 'package:provider/provider.dart';

class PurportFormRarity extends StatelessWidget {
  const PurportFormRarity({super.key});

  @override
  Widget build(BuildContext context) {
    final model = context.read<PurportFormModel>();
    final selectedRarity = context.select<PurportFormModel, PurportType>(
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
            children: PurportType.values
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
