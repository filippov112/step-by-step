import 'package:chaos_control/models/enums/wall_status.dart';
import 'package:flutter/material.dart';
import 'package:chaos_control/models/enums/wall_difficulty.dart';
import 'package:chaos_control/models/enums/wall_priority.dart';
import 'package:chaos_control/models/wall.dart';
import 'package:chaos_control/screens/walls/detail/wall_detail_model.dart';
import 'package:chaos_control/screens/walls/detail/wall_detail_screen.dart';
import 'package:chaos_control/screens/walls/list/task_list_model.dart';
import 'package:chaos_control/widgets/dialogs/confirm_dialog.dart';
import 'package:provider/provider.dart';

class TaskCard extends StatelessWidget {
  final Wall task;

  const TaskCard({super.key, required this.task});

  @override
  Widget build(BuildContext context) {
    final model = context.read<TaskListModel>();
    final isSelected = model.selectedIds.contains(task.id);
    Color? containterColor = task.status == WallStatus.destroyed
        ? Theme.of(
            context,
          ).colorScheme.surfaceContainerHighest.withValues(alpha: 0.5)
        : Theme.of(
            context,
          ).colorScheme.surfaceContainerHighest.withValues(alpha: 0.9);
    Gradient containterBorderColor = LinearGradient(
      transform: GradientRotation(0.7),
      colors: [task.priority.color.withValues(alpha: 0.5), containterColor],
      stops: [0, 0.2],
    );

    Color difficultyForeColor = task.status == WallStatus.destroyed
        ? task.difficulty.color.withValues(alpha: 0.2)
        : task.difficulty.color;
    Color difficultyBackColor = task.status == WallStatus.destroyed
        ? task.difficulty.color.withValues(alpha: 0.06)
        : task.difficulty.color.withValues(alpha: 0.2);
    Color? checkColor = Theme.of(context).focusColor.withAlpha(100);
    Color checkFillColor = task.status == WallStatus.destroyed
        ? Theme.of(context).focusColor.withValues(alpha: 0.3)
        : Theme.of(context).focusColor;
    Color titleColor = task.status == WallStatus.destroyed
        ? Theme.of(context).focusColor.withAlpha(100)
        : Theme.of(context).focusColor;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Container(
        decoration: BoxDecoration(
          gradient: containterBorderColor,
          borderRadius: BorderRadius.all(Radius.circular(16)),
          color: containterColor,
        ),
        child: InkWell(
          borderRadius: BorderRadius.all(Radius.circular(16)),
          onTap: () {
            if (model.isSelectionMode) {
              model.toggleSelectTask(task.id);
            } else {
              _openDetails(context, model, task);
            }
          },
          onLongPress: () {
            if (!model.isSelectionMode) {
              model.toggleSelectionMode();
              model.toggleSelectTask(task.id);
            }
          },
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                // Чекбокс для выделения или статуса
                Padding(
                  padding: EdgeInsetsGeometry.only(right: 12),
                  child: model.isSelectionMode
                      ? Checkbox(
                          value: isSelected,
                          onChanged: (_) => model.toggleSelectTask(task.id),
                        )
                      : Transform.scale(
                          scale: 2,
                          child: Checkbox(
                            value: task.status == WallStatus.destroyed,
                            onChanged: (_) => model.toggleTaskDone(task.id),
                            fillColor: WidgetStateProperty.resolveWith((
                              states,
                            ) {
                              if (states.contains(WidgetState.selected)) {
                                return checkFillColor;
                              }
                              return Theme.of(context).dividerColor;
                            }),
                            checkColor: checkColor,
                          ),
                        ),
                ),

                // Информация о задаче
                Expanded(
                  child: Text(
                    task.title,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      color: titleColor,
                    ),
                  ),
                ),

                _buildDifficultyChip(difficultyBackColor, difficultyForeColor),
                if (model.isSelectionMode) ...{
                  SizedBox(width: 8),
                  IconButton(
                    icon: const Icon(Icons.delete_outline, size: 16),
                    onPressed: () =>
                        _deleteTask(context, task, model.deleteTask),
                    tooltip: 'Удалить',
                  ),
                },
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _deleteTask(
    BuildContext context,
    Wall task,
    Future Function(String) deleteTask,
  ) async {
    if (await showConfirmDialog(context) == true) {
      await deleteTask(task.id);
    }
  }

  Widget _buildDifficultyChip(Color backColor, Color foreColor) {
    return Container(
      margin: EdgeInsets.only(left: 12),
      width: 32,
      height: 32,
      decoration: BoxDecoration(color: backColor, shape: BoxShape.circle),
      child: Icon(Icons.build, color: foreColor, size: 16),
    );
  }

  Future _openDetails(
    BuildContext context,
    TaskListModel model,
    Wall task,
  ) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ChangeNotifierProvider(
          create: (context) => WallDetailModel(),
          child: WallDetailsScreen(wall: task),
        ),
      ),
    );
    if (context.mounted) model.loadTasks();
  }
}
