import 'package:flutter/material.dart';
import 'package:life_game/models/enums/task_difficulty.dart';
import 'package:life_game/models/enums/task_priority.dart';
import 'package:life_game/models/task.dart';
import 'package:life_game/screens/tasks/detail/task_detail_model.dart';
import 'package:life_game/screens/tasks/detail/task_detail_screen.dart';
import 'package:life_game/screens/tasks/list/task_list_model.dart';
import 'package:life_game/widgets/dialogs/confirm_dialog.dart';
import 'package:provider/provider.dart';

class TaskCard extends StatelessWidget {
  final Task task;
  final int childrenCount;
  final int childrenDoneCount;

  const TaskCard({
    super.key, 
    required this.task,
    this.childrenCount = 0, 
    this.childrenDoneCount = 0
  });

  @override
  Widget build(BuildContext context) {
    
    final model = context.read<TaskListModel>();
    final isSelected = model.selectedIds.contains(task.id);
    final isOverdue = task.isOverdue;
    Color? containterColor = task.done
              ? Theme.of(context).colorScheme.surfaceContainerHighest.withValues(alpha: 0.5)
              : Theme.of(context).colorScheme.surfaceContainerHighest.withValues(alpha: 0.9);
    Gradient containterBorderColor = LinearGradient(
      transform: GradientRotation(0.7),
      colors: [task.priority.color.withValues(alpha: 0.5), containterColor],
      stops: [0, 0.2]);
    
    Color difficultyForeColor = task.done ? task.difficulty.color.withValues(alpha: 0.2) : task.difficulty.color;
    Color difficultyBackColor = task.done ? task.difficulty.color.withValues(alpha: 0.06) : task.difficulty.color.withValues(alpha: 0.2);
    Color? dateColor = task.isOverdue ? Theme.of(context).colorScheme.error : task.done ? Theme.of(context).textTheme.bodyLarge?.color?.withValues(alpha: 0.2) : Theme.of(context).textTheme.bodyLarge?.color;
    Color? checkColor =  Theme.of(context).focusColor.withAlpha(100);
    Color checkFillColor = task.done ? Theme.of(context).focusColor.withValues(alpha: 0.3) : Theme.of(context).focusColor;
    Color titleColor = task.done ? Theme.of(context).focusColor.withAlpha(100) : Theme.of(context).focusColor;
    Color counterColor = task.done ? Theme.of(context).focusColor.withAlpha(100) : Theme.of(context).focusColor.withValues(alpha:0.5);

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
                  child: model.isSelectionMode ? Checkbox(
                      value: isSelected,
                      onChanged: (_) => model.toggleSelectTask(task.id),
                    ) :
                    Transform.scale(
                      scale: 2,
                      child: Checkbox(
                        value: task.done,
                        onChanged: (_) => model.toggleTaskDone(task.id),
                        fillColor: WidgetStateProperty.resolveWith((states) {
                          if (states.contains(WidgetState.selected)) return checkFillColor;
                          return Theme.of(context).dividerColor;
                        }),
                        checkColor: checkColor,
                    ),
                  )
                    
                ),
                
                // Информация о задаче
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [

                      // Счетчик + заголовок
                      Row(
                        children: [
                          if (childrenCount > 0) ...{
                            Text(
                              '($childrenDoneCount / $childrenCount)',
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontWeight: FontWeight.w500,
                                color: counterColor,
                              ),
                            ),
                            SizedBox(width: 8,),
                          },
                          Expanded(
                            child: Text(
                              task.title,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontWeight: FontWeight.w500,
                                color: titleColor,
                              ),
                            ),
                          )
                        ],
                      ),
                      const SizedBox(height: 4),

                      // Дата-время
                      _buildDateTimeChip(context, task.datetime, dateColor),
                    ],
                  ),
                ),

                // Индикатор просрочки
                if (isOverdue && !task.done)
                  Padding(
                    padding: EdgeInsetsGeometry.only(left:12),
                    child: Icon(
                      Icons.warning_amber_rounded,
                      color: Theme.of(context).colorScheme.error,
                    ),
                  ),
                _buildDifficultyChip(difficultyBackColor, difficultyForeColor),
                if (model.isSelectionMode) ...{
                  SizedBox(width: 8,),
                  IconButton(
                    icon: const Icon(Icons.delete_outline, size: 16),
                    onPressed: () => _deleteTask(context, task, model.deleteTask),
                    tooltip: 'Удалить',
                  ),
                }
              ],
            ),
          ),
        ),
      )
    );
  }

  Future<void> _deleteTask(BuildContext context, Task task, Future Function(String) deleteTask) async {
    if (await showConfirmDialog(context) == true) {
      await deleteTask(task.id);
    }
  }

  Widget _buildDifficultyChip(Color backColor, Color foreColor) {
    return Container(
      margin: EdgeInsets.only(left:12),
      width: 32,
      height: 32,
      decoration: BoxDecoration(
        color: backColor,
        shape: BoxShape.circle,
      ),
      child: Icon(Icons.build, color: foreColor, size: 16,)
    );
  }

  Widget _buildDateTimeChip(BuildContext context, DateTime? datetime, Color? color) {
    return datetime == null ? const Text('') : Text(
      '${datetime.day}.${datetime.month}.${datetime.year} ${datetime.hour}:${datetime.minute.toString().padLeft(2, '0')}',
      style: TextStyle(
        fontSize: 12,
        color: color,
      ),
    );
  }

  Future _openDetails(BuildContext context, TaskListModel model, Task task) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ChangeNotifierProvider(
          create: (context) => TaskDetailModel(), 
          child: TaskDetailsScreen(task: task),
        ),
      ),
    );
    if (context.mounted) model.loadTasks(); 
  }
}