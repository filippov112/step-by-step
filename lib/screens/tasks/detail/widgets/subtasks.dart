import 'package:flutter/material.dart';
import 'package:chaos_control/models/task.dart';
import 'package:chaos_control/screens/tasks/detail/task_detail_model.dart';
import 'package:chaos_control/screens/tasks/detail/widgets/tile.dart';
import 'package:chaos_control/widgets/common/empty_list_screen.dart';
import 'package:provider/provider.dart';


// Шапка подзадач
class TaskDetailSubtasksHeader extends StatelessWidget {
  final ExpansibleController expController;
  final VoidCallback onExpansionChanged;

  const TaskDetailSubtasksHeader({
    super.key,
    required this.expController,
    required this.onExpansionChanged,
  });

  @override
  Widget build(BuildContext context) {
    final subtasks = context.select<TaskDetailModel, List<Task>>(
      (model) => model.subtasks,
    );

    return ExpansionTile(
      controller: expController,
      onExpansionChanged: (_) {
        onExpansionChanged.call();
      },
      title: Text(
        'Подзадачи (${subtasks.where((e) => e.done).length} / ${subtasks.length})',
        style: Theme.of(context).textTheme.titleMedium,
      ),
      leading: Icon(Icons.task_alt_outlined),
      children: [],
    );
  }
}

// Блок подзадач
class TaskDetailSubtasksBlock extends StatelessWidget {
  final ExpansibleController expController;
  final VoidCallback onExpansionChanged;

  const TaskDetailSubtasksBlock({
    super.key,
    required this.expController,
    required this.onExpansionChanged,
  });

  @override
  Widget build(BuildContext context) {
    final model = context.read<TaskDetailModel>();
    final subtasks = context.select<TaskDetailModel, List<Task>>(
      (model) => model.subtasks,
    );
    final childrenCount = context.select<TaskDetailModel, Map<String, int>>(
      (model) => model.childTasksCount,
    );
    final childrenDoneCount = context.select<TaskDetailModel, Map<String, int>>(
      (model) => model.childDoneTasksCount,
    );
    var isLoading = context.select<TaskDetailModel, bool>(
      (model) => model.isLoading,
    );

    return isLoading
        ? const Center(child: CircularProgressIndicator())
        : subtasks.isEmpty
        ? EmptyListScreen(
            title: "Подзадач нет",
            subtitle: "Добавьте подзадачу, чтобы разбить основную на части",
            icon: Icons.task_alt_outlined,
          )
        : SizedBox(
            height: 400,
            child: Padding(
              padding: EdgeInsetsGeometry.all(8),
              child: ListView.builder(
                itemCount: subtasks.length,
                itemBuilder: (context, index) {
                  return DetailTaskCard(
                    model: model,
                    task: subtasks[index],
                    childrenCount: childrenCount[subtasks[index].id] ?? 0,
                    childrenDoneCount:
                        childrenDoneCount[subtasks[index].id] ?? 0,
                  );
                },
              ),
            ),
          );
  }
}
