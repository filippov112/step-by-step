import 'package:flutter/material.dart';
import 'package:life_game/models/enums/task_difficulty.dart';
import 'package:life_game/models/enums/task_priority.dart';
import 'package:life_game/models/tag.dart';
import 'package:life_game/models/task.dart';
import 'package:life_game/screens/tasks/detail/task_detail_model.dart';
import 'package:life_game/screens/tasks/detail/widgets/desc_chip.dart';
import 'package:life_game/widgets/common/tag_chip.dart';
import 'package:provider/provider.dart';

class TaskDetailStatus extends StatelessWidget {
  const TaskDetailStatus({super.key});

  @override
  Widget build(BuildContext context) {
    var datetime = context.select<TaskDetailModel, DateTime?>(
      (model) => model.task.datetime,
    );
    var priority = context.select<TaskDetailModel, TaskPriority>(
      (model) => model.task.priority,
    );
    var difficulty = context.select<TaskDetailModel, TaskDifficulty>(
      (model) => model.task.difficulty,
    );
    var allTags = context.select<TaskDetailModel, List<Tag>>(
      (model) => model.allTags,
    );
    var done = context.select<TaskDetailModel, bool>(
      (model) => model.task.done,
    );
    var isOverdue = context.select<TaskDetailModel, bool>(
      (model) => model.task.isOverdue,
    );

    return Padding(
      padding: EdgeInsetsGeometry.all(8),
      child: Wrap(
        spacing: 8,
        runSpacing: 8,
        children: [
          if (datetime != null)
            TaskDetailDescChip(
              icon: Icons.event,
              label:
                  '${datetime.day}.${datetime.month}.${datetime.year} ${datetime.hour}:${datetime.minute.toString().padLeft(2, '0')}',
              color: isOverdue && !done
                  ? Theme.of(context).colorScheme.error
                  : null,
            ),
          TaskDetailDescChip(
            icon: Icons.priority_high,
            label: priority.displayName,
            color: priority.color,
          ),
          TaskDetailDescChip(
            icon: Icons.build,
            label: difficulty.displayName,
            color: difficulty.color,
          ),
          ...allTags.map((tag) => TagChip(title: tag.title)),
        ],
      ),
    );
  }
}
