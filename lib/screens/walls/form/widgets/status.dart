import 'package:chaos_control/models/enums/wall_status.dart';
import 'package:flutter/material.dart';
import 'package:chaos_control/screens/walls/form/wall_form_model.dart';
import 'package:provider/provider.dart';

class WallFormStatus extends StatelessWidget {
  const WallFormStatus({super.key});

  @override
  Widget build(BuildContext context) {
    final status = context.select<WallFormModel, WallStatus>(
      (model) => model.status,
    );
    final setStatus = context.read<WallFormModel>().setStatus;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Статус', style: Theme.of(context).textTheme.titleMedium),
        const SizedBox(height: 8),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: WallStatus.values
                .map(
                  (value) => Padding(
                    padding: EdgeInsetsGeometry.only(right: 8),
                    child: ChoiceChip(
                      label: Text(value.name),
                      selected: status == value,
                      onSelected: (_) => setStatus(value),
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
