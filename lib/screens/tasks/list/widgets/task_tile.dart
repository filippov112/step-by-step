import 'package:flutter/material.dart';
import 'package:life_game/models/task.dart';
import 'package:life_game/models/enums/task_priority.dart';
import 'package:life_game/models/enums/task_difficulty.dart';

class TaskTile extends StatelessWidget {
  final Task task;
  final VoidCallback? onTap;
  final Function(Task task, bool?) completeTask;

  const TaskTile({
    super.key,
    required this.task,
    this.onTap,
    required this.completeTask
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      color: task.done ? Colors.grey.shade100 : Colors.white,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(0,14,14,14),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Статус Done (чекбокс)
            Padding(padding:EdgeInsetsGeometry.fromLTRB(14,14,14,14), child:Checkbox(
              value: task.done,
              onChanged: (value) {
                completeTask(task, value);
              },
            ),),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Заголовок + приоритет и сложность (цветной индикатор)
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Заголовок
                      Expanded(
                        child: Text(
                          task.title,
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            decoration: task.done ? TextDecoration.lineThrough : null,
                            color: task.done ? Colors.grey : Colors.black87,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Row(
                        children: [
                          // Приоритет
                          Container(
                            // width: 12,
                            // height: 12,
                            padding: EdgeInsets.all(3),
                            decoration: BoxDecoration(
                              color: task.priority.color.withAlpha(120),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(Icons.priority_high, color: task.priority.color),
                          ),
                          SizedBox(width: 5),
                          // Сложность
                          Container(
                            // width: 12,
                            // height: 12,
                            padding: EdgeInsets.all(3),
                            decoration: BoxDecoration(
                              color: task.difficulty.color.withAlpha(120),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(Icons.hardware, color: task.difficulty.color)
                          ),
                        ]
                      ),
                    ],
                  ),

                  const SizedBox(height: 4),

                  // Описание
                  if (task.description.isNotEmpty)
                    Text(
                      task.description,
                      style: TextStyle(
                        color: task.done ? Colors.grey : Colors.black54,
                        fontSize: 14,
                        decoration: task.done ? TextDecoration.lineThrough : null,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),

                  const SizedBox(height: 6),

                  // Время + длительность
                  Row(
                    children: [
                      if (task.datetime != null) ...[
                        Icon(Icons.calendar_today, size: 16, color: Colors.grey.shade600),
                        const SizedBox(width: 4),
                        Text(
                          '${task.datetime!.day}.${task.datetime!.month}.${task.datetime!.year} ${task.datetime!.hour.toString().padLeft(2, '0')}:${task.datetime!.minute.toString().padLeft(2, '0')}',
                          style: const TextStyle(fontSize: 13, color: Colors.grey),
                        ),
                        const SizedBox(width: 16),
                      ],
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}