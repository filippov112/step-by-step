import 'package:chaos_control/screens/targets/edit/widgets/chars.dart';
import 'package:chaos_control/screens/targets/edit/widgets/favorite.dart';
import 'package:chaos_control/screens/targets/edit/widgets/project.dart';
import 'package:flutter/material.dart';
import 'package:chaos_control/models/target.dart';
import 'package:chaos_control/screens/targets/edit/target_edit_model.dart';
import 'package:chaos_control/widgets/dialogs/confirm_dialog.dart';
import 'package:chaos_control/widgets/form/text_input.dart';
import 'package:chaos_control/widgets/screens/entity_screen.dart';
import 'package:provider/provider.dart';

class TargetEditScreen extends StatefulWidget {
  final Target? target;
  final Target? parent;

  const TargetEditScreen({super.key, this.target, this.parent});

  @override
  State<TargetEditScreen> createState() => _TargetEditScreenState();
}

class _TargetEditScreenState extends State<TargetEditScreen> {
  final _formKey = GlobalKey<FormState>();
  late TargetEditModel model;
  late TextEditingController titleController, groupController, targetController;

  @override
  void initState() {
    super.initState();
    model = context.read<TargetEditModel>();
    titleController = TextEditingController(text: widget.target?.title);
    targetController = TextEditingController(text: widget.target?.desc);
    groupController = TextEditingController(text: widget.target?.group);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      model.setTarget(widget.target);
    });
  }

  @override
  void dispose() {
    titleController.dispose();
    targetController.dispose();
    groupController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final saveTask = model.save;
    final deleteTask = model.delete;

    return EntityScreen(
      title: 'Цель',
      formKey: _formKey,
      deleteCallback: widget.target == null
          ? null
          : () => _deleteTask(deleteTask),
      saveCallback: () => _saveTask(saveTask),
      children: [

        // Проект
        const TargetEditProject(),

        // Название
        CustomTextInput(
          requiredErrorText: 'Введите название',
          header: 'Название',
          setText: model.setTitle,
          icon: Icons.title,
          controller: titleController,
        ),
        const SizedBox(height: 12),

        // Группа
        CustomTextInput(
          header: 'Группа',
          controller: groupController,
          icon: Icons.folder,
          setText: model.setGroup,
          lines:1,
          customValidator: model.groupValidator,
        ),
        const SizedBox(height: 12),

        // Описание
        CustomTextInput(
          header: 'Описание',
          setText: model.setDesc,
          icon: Icons.center_focus_weak_rounded,
          controller: targetController,
          lines: 4,
        ),
        const SizedBox(height: 12),

        // Избранная
        const TargetEditFavorite(),

        // Распределение опыта
        const TargetEditChars(),
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
