import 'package:chaos_control/models/barrier.dart';
import 'package:chaos_control/screens/targets/detail/target_detail_model.dart';
import 'package:chaos_control/screens/tasks/widgets/task_form.dart';
import 'package:chaos_control/screens/tasks/widgets/task_tile.dart';
import 'package:chaos_control/screens/tasks/widgets/tasks_appbar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class TargetDetailTaskTab extends StatelessWidget {
  const TargetDetailTaskTab({super.key});

  @override
  Widget build(BuildContext context) {
    final tasks = context.select<TargetDetailModel, List<Barrier>>(
      (m) => m.tasks,
    );


    final listTasks = Expanded(
          child: Container(
            padding: EdgeInsets.all(12),
            child: ListView.builder(
              itemCount: tasks.length,
              itemBuilder: (context, index) {
                return TargetDetailTaskTile(task: tasks[index]);
              },
            ),
          ),
        );

    return Column(
      children: [
        const TargetDetailTasksAppbar(),
        listTasks,
        const TargetDetailTaskForm()
      ],
    );
  }
}
