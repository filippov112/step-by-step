import 'package:flutter/material.dart';
import 'package:chaos_control/screens/tasks/detail/task_detail_model.dart';
import 'package:provider/provider.dart';

class TaskDetailDesc extends StatelessWidget {
  const TaskDetailDesc({super.key});

  @override
  Widget build(BuildContext context) {
    var description = context.select<TaskDetailModel, String>(
      (model) => model.task.description,
    );

    return Text(description, style: Theme.of(context).textTheme.bodyLarge);
  }
}
