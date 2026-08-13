import 'package:flutter/material.dart';
import 'package:life_game/models/enums/task_difficulty.dart';
import 'package:life_game/models/enums/task_priority.dart';
import 'package:life_game/models/tag.dart';
import 'package:life_game/widgets/common/tag_chip.dart';

Widget buildStatusSection(
  BuildContext context,
{
  required bool done,
  required DateTime? datetime,
  required bool isOverdue,
  required TaskPriority priority,
  required TaskDifficulty difficulty,
  required List<Tag> allTags
}) {
  return Padding(
    padding: EdgeInsetsGeometry.all(8),
    child: Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        if (datetime != null)
          _buildInfoChip(
            context,
            icon: Icons.event,
            label: '${datetime.day}.${datetime.month}.${datetime.year} ${datetime.hour}:${datetime.minute.toString().padLeft(2, '0')}',
            color: isOverdue && !done
                ? Colors.red
                : null,
          ),
        _buildInfoChip(
          context,
          icon: Icons.priority_high,
          label: priority.displayName,
          color: priority.color,
        ),
        _buildInfoChip(
          context,
          icon: Icons.build,
          label: difficulty.displayName,
          color: difficulty.color,
        ),
        ...allTags.map((tag) =>
          TagChip(
            title: tag.title
          ),
        )
      ],
    ),
  );    
}

Widget _buildInfoChip(
  BuildContext context, 
{
  required IconData icon,
  required String label,
  Color? color,
}) {
  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
    decoration: BoxDecoration(
      color: color?.withValues(alpha: 0.15) ?? Theme.of(context).dividerColor,
      borderRadius: BorderRadius.circular(12),
    ),
    child: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 14, color: color),
        const SizedBox(width: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: color,
          ),
        ),
      ],
    ),
  );
}
