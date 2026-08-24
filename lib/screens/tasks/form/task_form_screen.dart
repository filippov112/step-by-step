import 'package:flutter/material.dart';
import 'package:life_game/models/task.dart';
import 'package:life_game/screens/tasks/form/task_form_model.dart';
import 'package:life_game/screens/tasks/form/widgets/rewards.dart';
import 'package:life_game/screens/tasks/form/widgets/tags.dart';
import 'package:life_game/screens/tasks/form/widgets/datetime.dart';
import 'package:life_game/screens/tasks/form/widgets/difficulty.dart';
import 'package:life_game/screens/tasks/form/widgets/priority.dart';
import 'package:life_game/screens/tasks/form/widgets/status.dart';
import 'package:life_game/widgets/dialogs/confirm_dialog.dart';
import 'package:life_game/widgets/form/multiline_input.dart';
import 'package:life_game/widgets/form/singleline_input.dart';
import 'package:life_game/widgets/screens/entity_screen.dart';
import 'package:provider/provider.dart';

class TaskFormScreen extends StatefulWidget {
  final Task? task;
  final Task? parent;

  const TaskFormScreen({super.key, this.task, this.parent});

  @override
  State<TaskFormScreen> createState() => _TaskFormScreenState();
}

class _TaskFormScreenState extends State<TaskFormScreen> {
  final _formKey = GlobalKey<FormState>();
  late TaskFormModel model;
  late TextEditingController titleController;
  late TextEditingController descController;

  @override
  void initState() {
    super.initState();
    model = context.read<TaskFormModel>();
    titleController = TextEditingController(text: widget.task?.title);
    descController = TextEditingController(text: widget.task?.description);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      model.setTask(widget.task, widget.parent);
    });
  }

  @override
  void dispose() {
    titleController.dispose();
    descController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final saveTask = model.saveTask;
    final deleteTask = model.deleteTask;

    return EntityScreen(
      title: 'Задача',
      formKey: _formKey,
      deleteCallback: widget.task == null
          ? () {}
          : () => _deleteTask(deleteTask),
      saveCallback: () => _saveTask(saveTask),
      children: [
        // Название
        SinglelineInput(
          requiredErrorText: 'Введите название',
          header: 'Название',
          setText: model.setTitle,
          controller: titleController,
        ),
        const SizedBox(height: 12),

        // Описание
        CustomMultilineTextInput(header: 'Описание', setText: model.setDescription, controller: descController),
        const SizedBox(height: 12),

        // Дата и время
        const TaskFormDatetime(),
        const SizedBox(height: 12),

        // Статус
        const TaskFormStatus(),
        const SizedBox(height: 12),

        // Приоритет
        const TaskFormPriority(),
        const SizedBox(height: 12),

        // Сложность
        const TaskFormDifficulty(),
        const SizedBox(height: 12),

        // Теги
        const TaskFormTags(),
        const SizedBox(height: 12),

        // Награды
        const TaskFormRewards(),
      ],
    );
  }

  Future _saveTask(Future<bool> Function() saveTask) async {
    if (!mounted || _formKey.currentState == null) return;
    if (!(_formKey.currentState?.validate() ?? false)) return;

    var result = await saveTask();
    if (mounted) {
      Navigator.pop(context, result);
    }
  }

  Future _deleteTask(Future Function() deleteTask) async {
    if (await showConfirmDialog(context) == true && context.mounted) {
      await deleteTask();
      if (context.mounted) {
        Navigator.pop(context);
      }
    }
  }
}
