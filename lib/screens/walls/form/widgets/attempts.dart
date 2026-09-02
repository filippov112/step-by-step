import 'package:flutter/material.dart';
import 'package:chaos_control/models/attempt.dart';
import 'package:chaos_control/screens/walls/form/wall_form_model.dart';
import 'package:chaos_control/screens/walls/form/widgets/attempt_dialog.dart';
import 'package:chaos_control/screens/walls/form/widgets/attempt_tile.dart';
import 'package:provider/provider.dart';

class WallFormAttempts extends StatelessWidget {
  const WallFormAttempts({super.key});

  @override
  Widget build(BuildContext context) {
    final taskId = context.select<WallFormModel, String>(
      (model) => model.wall.id,
    );
    final selectedRewards = context.select<WallFormModel, List<Attempt>>(
      (model) => model.selectedRewards,
    );
    final setSelectedRewards = context.read<WallFormModel>().setSelectedRewards;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Награды', style: Theme.of(context).textTheme.titleMedium),
            IconButton(
              onPressed: () => showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                builder: (context) => AttemptDialog(
                  onConfirm: (rewards) => setSelectedRewards(rewards),
                  taskId: taskId,
                  selectedRewards: selectedRewards,
                ),
              ),
              icon: const Icon(Icons.add, size: 16),
            ),
          ],
        ),
        Text(
          'Всего: ${sum(selectedRewards.map((r) => r.efforts).toList())} EXP',
          style: Theme.of(context).textTheme.titleSmall,
        ),
        const SizedBox(height: 8),
        SizedBox(
          height: 300,
          child: ListView(
            children: [
              ...selectedRewards.map((reward) {
                

                return AttemptTile(
                  isClass: true,
                  title: '',
                  exp: reward.efforts,
                  time: 0,
                  selected: true,
                  focused: false,
                );
              }),
            ],
          ),
        ),
        if (selectedRewards.isEmpty)
          Text(
            'Награды не добавлены',
            style: Theme.of(
              context,
            ).textTheme.bodySmall?.copyWith(color: Theme.of(context).hintColor),
          ),
      ],
    );
  }

  int sum(List<int> values) {
    int r = 0;
    for (var v in values) {
      r += v;
    }
    return r;
  }
}
