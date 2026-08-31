import 'package:flutter/material.dart';
import 'package:chaos_control/models/enums/wall_difficulty.dart';
import 'package:chaos_control/models/enums/wall_priority.dart';
import 'package:chaos_control/screens/walls/detail/wall_detail_model.dart';
import 'package:chaos_control/screens/walls/detail/widgets/desc_chip.dart';
import 'package:provider/provider.dart';

class WallDetailStatus extends StatelessWidget {
  const WallDetailStatus({super.key});

  @override
  Widget build(BuildContext context) {
    var priority = context.select<WallDetailModel, WallPriority>(
      (model) => model.wall.priority,
    );
    var difficulty = context.select<WallDetailModel, WallDiff>(
      (model) => model.wall.difficulty,
    );

    return Padding(
      padding: EdgeInsetsGeometry.all(8),
      child: Wrap(
        spacing: 8,
        runSpacing: 8,
        children: [
          WallDetailDescChip(
            icon: Icons.priority_high,
            label: priority.displayName,
            color: priority.color,
          ),
          WallDetailDescChip(
            icon: Icons.build,
            label: difficulty.name,
            color: difficulty.color,
          ),
        ],
      ),
    );
  }
}
