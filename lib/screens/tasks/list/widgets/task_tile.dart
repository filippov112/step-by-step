import 'package:flutter/material.dart';
import 'package:life_game/models/task.dart';

class TaskTile extends StatefulWidget {
  const TaskTile({super.key, required this.task});

  final TaskModel task;

  @override
  State<TaskTile> createState() => _TaskTileState();
}

class _TaskTileState extends State<TaskTile> {
  // ViewModel - команды, свойства

  @override
  Widget build(BuildContext context) { // Виджет родитель
    // Верстка
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: Colors.grey)),
      ),
      child: Row(
        children: [
          Icon(Icons.task),
          SizedBox(width: 12),
          Text(widget.task.title),
          Spacer(),           // занимает всё свободное место
          Text('+${widget.task.exp} XP'),
        ],
      ),
    );
  }
}