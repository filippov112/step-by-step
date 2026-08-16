import 'package:flutter/material.dart';
import 'package:life_game/models/enums/task_difficulty.dart';
import 'package:life_game/models/enums/task_priority.dart';
import 'package:life_game/models/tag.dart';
import 'package:life_game/screens/tasks/detail/widgets/status.dart';
import 'package:life_game/themes/solo_leveling_theme.dart';

Widget buildTaskInfo(
  BuildContext context,
  {
    required bool done,
    required DateTime? datetime,
    required bool isOverdue,
    required TaskPriority priority,
    required TaskDifficulty difficulty,
    required List<Tag> allTags,
    required String description,
  }
) {
  return Padding(
    padding: EdgeInsetsGeometry.all(16),
    child: ListView(
      children: [
          
        buildStatusSection(
          context,
          done: done, 
          datetime: datetime, 
          isOverdue: isOverdue, 
          priority: priority, 
          difficulty: difficulty, 
          allTags: allTags
        ),

        const Divider(),

        Text(
          description,
          style: Theme.of(context).textTheme.bodyLarge,
        ),
      ]
    )
  );
}