import 'package:chaos_control/screens/tasks/task_form_model.dart';
import 'package:chaos_control/screens/targets/detail/target_detail_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class TargetDetailAddTaskButton extends StatelessWidget {
  const TargetDetailAddTaskButton({super.key,});

  @override
  Widget build(BuildContext context) {
    final model = context.read<TargetDetailModel>();
    final formModel = context.read<TaskFormModel>();

    return FloatingActionButton(
      onPressed: () { model.openForm(null); formModel.initTask(null, model.target, model.tasks.length); },
      tooltip: 'Добавить задачу',
      backgroundColor: Theme.of(context).focusColor,
      child: Icon(Icons.sports_martial_arts, color: Theme.of(context).primaryColor),
    );
  }
}
