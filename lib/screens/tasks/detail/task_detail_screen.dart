import 'package:flutter/material.dart';
import 'package:life_game/models/task.dart';
import 'package:life_game/screens/tasks/detail/task_detail_model.dart';
import 'package:life_game/screens/tasks/detail/widgets/description.dart';
import 'package:life_game/screens/tasks/detail/widgets/title.dart';
import 'package:life_game/screens/tasks/detail/widgets/status.dart';
import 'package:life_game/screens/tasks/detail/widgets/subtasks.dart';
import 'package:life_game/screens/tasks/form/task_form_screen.dart';
import 'package:life_game/widgets/dialogs/confirm_dialog.dart';
import 'package:life_game/widgets/screens/entity_screen.dart';
import 'package:provider/provider.dart';

class TaskDetailsScreen extends StatefulWidget {
  final Task task;
  const TaskDetailsScreen({super.key, required this.task});

  @override
  State<TaskDetailsScreen> createState() => _TaskDetailsScreenState();
}

class _TaskDetailsScreenState extends State<TaskDetailsScreen> {
  late TaskDetailModel model;
  var expController = ExpansibleController();

  @override
  void initState() {
    super.initState();
    model = context.read<TaskDetailModel>();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      model.setTask(widget.task);
    });
  }

  @override
  void dispose() {
    expController.dispose();
    super.dispose();
  }

  Future<void> _loadSubtasks() async {
    await model.loadSubtasks();
  }

  @override
  Widget build(BuildContext context) {
    var task = context.select<TaskDetailModel, Task>((model) => model.task);
    var done = context.select<TaskDetailModel, bool>(
      (model) => model.task.done,
    );

    var setDone = model.setDone;
    var deleteThisTask = model.deleteThisTask;

    return EntityScreen(
      title: 'Задача',
      editCallback: () => _editTask(model, task),
      deleteCallback: () => _deleteThisTask(deleteThisTask),
      floatingButton: expController.isExpanded
          ? FloatingActionButton(
              onPressed: () => _createSubtask(task),
              tooltip: 'Добавить подзадачу',
              child: const Icon(Icons.add),
            )
          : FloatingActionButton(
              onPressed: () => setDone(),
              tooltip: 'Добавить подзадачу',
              backgroundColor: Theme.of(context).focusColor,
              child: Icon(
                done ? Icons.task_alt_outlined : Icons.circle_outlined,
                color: Theme.of(context).primaryColor,
              ),
            ),
      child: Column(
        children: [
          // Заголовок
          Padding(
            padding: const EdgeInsets.all(16),
            child: const TaskDetailTitle(),
          ),

          // Шапка списка подзадач
          TaskDetailSubtasksHeader(
            expController: expController,
            onExpansionChanged: () => setState(() {}),
          ),

          Divider(),

          // Основной блок - подзадачи, либо описание
          Expanded(
            child: expController.isExpanded
                ? TaskDetailSubtasksBlock(
                    expController: expController,
                    onExpansionChanged: () => setState(() {}),
                  )
                : Padding(
                    padding: EdgeInsetsGeometry.all(16),
                    child: ListView(
                      children: [
                        const TaskDetailStatus(),
                        const Divider(),
                        const TaskDetailDesc(),
                      ],
                    ),
                  ),
          ),
        ],
      ),
    );
  }

  Future<void> _createSubtask(Task currentTask) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => TaskFormScreen(parent: currentTask),
      ),
    );

    if (result == true) {
      await _loadSubtasks();
    }
  }

  void _editTask(TaskDetailModel model, Task task) async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => TaskFormScreen(task: task)),
    ).then((_) async {
      if (context.mounted) {
        var checkExistTask = await model.checkExist();
        if (!checkExistTask && context.mounted) {
          Navigator.pop(context);
          return;
        }
        model.loadSubtasks();
      }
    });
  }

  Future _deleteThisTask(Future Function() deleteTask) async {
    if (await showConfirmDialog(context) == true && context.mounted) {
      await deleteTask();
      if (context.mounted) {
        Navigator.pop(context);
      }
    }
  }
}
