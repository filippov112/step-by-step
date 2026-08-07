import 'package:flutter/material.dart';
import 'package:life_game/models/task.dart';

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
                              shape: BoxShape.circle,
                            ),
                            child: Icon(Icons.priority_high),
                          ),
                          SizedBox(width: 5),
                          // Сложность
                          Container(
                            // width: 12,
                            // height: 12,
                            padding: EdgeInsets.all(3),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                            ),
                            child: Icon(Icons.hardware)
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
                        Icon(Icons.calendar_today, size: 16),
                        const SizedBox(width: 4),
                        Text(
                          '${task.datetime!.day}.${task.datetime!.month}.${task.datetime!.year} ${task.datetime!.hour.toString().padLeft(2, '0')}:${task.datetime!.minute.toString().padLeft(2, '0')}',
                          style: const TextStyle(fontSize: 13),
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