import 'package:chaos_control/screens/walls/form/widgets/dates.dart';
import 'package:chaos_control/screens/walls/form/widgets/favorite.dart';
import 'package:chaos_control/screens/walls/form/widgets/project.dart';
import 'package:flutter/material.dart';
import 'package:chaos_control/models/wall.dart';
import 'package:chaos_control/screens/walls/form/wall_form_model.dart';
import 'package:chaos_control/screens/walls/form/widgets/difficulty.dart';
import 'package:chaos_control/screens/walls/form/widgets/status.dart';
import 'package:chaos_control/widgets/dialogs/confirm_dialog.dart';
import 'package:chaos_control/widgets/form/text_input.dart';
import 'package:chaos_control/widgets/screens/entity_screen.dart';
import 'package:provider/provider.dart';

class WallFormScreen extends StatefulWidget {
  final Wall? wall;
  final Wall? parent;

  const WallFormScreen({super.key, this.wall, this.parent});

  @override
  State<WallFormScreen> createState() => _WallFormScreenState();
}

class _WallFormScreenState extends State<WallFormScreen> {
  final _formKey = GlobalKey<FormState>();
  late WallFormModel model;
  late TextEditingController titleController, groupController, targetController;

  @override
  void initState() {
    super.initState();
    model = context.read<WallFormModel>();
    titleController = TextEditingController(text: widget.wall?.title);
    targetController = TextEditingController(text: widget.wall?.target);
    groupController = TextEditingController(text: widget.wall?.group);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      model.setWall(widget.wall);
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
      title: 'Стена',
      formKey: _formKey,
      deleteCallback: widget.wall == null
          ? null
          : () => _deleteTask(deleteTask),
      saveCallback: () => _saveTask(saveTask),
      children: [

        // Проект
        const WallFormProject(),

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

        // Цель
        CustomTextInput(
          header: 'Цель',
          setText: model.setTarget,
          icon: Icons.center_focus_weak_rounded,
          controller: targetController,
          lines: 4,
        ),
        const SizedBox(height: 12),

        // Статус
        const WallFormStatus(),
        const SizedBox(height: 12),

        // Сложность
        const TaskFormDifficulty(),
        const SizedBox(height: 12),

        // Даты создания и разрушения
        const WallFormDates(),
        const SizedBox(height: 12),

        // Избранная
        const WallFormFavorite()
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
