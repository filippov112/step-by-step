import 'package:flutter/material.dart';
import 'package:chaos_control/screens/tasks/detail/task_detail_model.dart';
import 'package:chaos_control/widgets/common/custom_text.dart';
import 'package:provider/provider.dart';

class TaskDetailTitle extends StatelessWidget {
  const TaskDetailTitle({super.key});

  @override
  Widget build(BuildContext context) {
    var title = context.select<TaskDetailModel, String>(
      (model) => model.task.title,
    );
    return CustomText(
      title,
      size: 20,
      weight: const FontWeight(500),
      lines: 3,
      padding: EdgeInsets.all(8),
    );
  }
}
