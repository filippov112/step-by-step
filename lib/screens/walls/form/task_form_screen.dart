import 'package:flutter/material.dart';
import 'package:chaos_control/models/wall.dart';
import 'package:chaos_control/screens/walls/form/task_form_model.dart';
import 'package:chaos_control/screens/walls/form/widgets/rewards.dart';
import 'package:chaos_control/screens/walls/form/widgets/difficulty.dart';
import 'package:chaos_control/screens/walls/form/widgets/status.dart';
import 'package:chaos_control/widgets/dialogs/confirm_dialog.dart';
import 'package:chaos_control/widgets/form/text_input.dart';
import 'package:chaos_control/widgets/screens/entity_screen.dart';
import 'package:provider/provider.dart';

class TaskFormScreen extends StatefulWidget {
  final Wall? task;
  final Wall? parent;

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
    descController = TextEditingController(text: widget.task?.target);
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
          ? null
          : () => _deleteTask(deleteTask),
      saveCallback: () => _saveTask(saveTask),
      children: [
        // Название
        CustomTextInput(
          requiredErrorText: 'Введите название',
          header: 'Название',
          setText: model.setTitle,
          icon: Icons.title,
          controller: titleController,
        ),
        const SizedBox(height: 12),

        // Описание
        CustomTextInput(
          header: 'Описание',
          setText: model.setDescription,
          icon: Icons.description,
          controller: descController,
        ),
        const SizedBox(height: 12),

        // Статус
        const TaskFormStatus(),
        const SizedBox(height: 12),

        // Сложность
        const TaskFormDifficulty(),
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

  void _close() {
    if (context.mounted) {
      Navigator.pop(context);
    }
  }

  Future _deleteTask(Future Function() deleteTask) async {
    if (await showConfirmDialog(context) == true && context.mounted) {
      await deleteTask();
      _close();
    }
  }
}
