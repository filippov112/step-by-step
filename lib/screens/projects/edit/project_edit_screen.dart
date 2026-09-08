import 'package:chaos_control/screens/projects/create/widgets/hidden.dart';
import 'package:chaos_control/screens/projects/edit/widgets/hidden.dart';
import 'package:chaos_control/screens/projects/edit/widgets/icon.dart';
import 'package:flutter/material.dart';
import 'package:chaos_control/models/project.dart';
import 'package:chaos_control/screens/projects/create/widgets/icon.dart';
import 'package:chaos_control/widgets/form/text_input.dart';
import 'package:chaos_control/screens/projects/edit/project_edit_model.dart';
import 'package:chaos_control/widgets/dialogs/confirm_dialog.dart';
import 'package:chaos_control/widgets/screens/entity_screen.dart';
import 'package:provider/provider.dart';

class ProjectEditScreen extends StatefulWidget {
  final Project project;

  const ProjectEditScreen({super.key, required this.project});

  @override
  State<ProjectEditScreen> createState() => _ProjectEditScreenState();
}

class _ProjectEditScreenState extends State<ProjectEditScreen> {
  final _formKey = GlobalKey<FormState>();
  late ProjectEditModel model;
  late TextEditingController titleController, targetController, groupController;

  @override
  void dispose() {
    titleController.dispose();
    targetController.dispose();
    groupController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    model = context.read<ProjectEditModel>();
    titleController = TextEditingController(text: widget.project?.title);
    targetController = TextEditingController(text: widget.project?.target);
    groupController = TextEditingController(text: widget.project?.group);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      model.setProject(widget.project);
    });
  }

  @override
  Widget build(BuildContext context) {
    var save = model.save;
    var delete = model.delete;

    return EntityScreen(
      title: 'Проект',
      saveCallback: () => _save(save),
      deleteCallback: () => _delete(delete),
      formKey: _formKey,
      children: [
        // Иконка
        const ProjectEditIcon(),
        const SizedBox(height: 12),

        // Название
        CustomTextInput(
          requiredErrorText: 'Введите название',
          header: 'Название',
          controller: titleController,
          icon: Icons.title,
          setText: model.setTitle,
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
          controller: targetController,
          icon: Icons.mode_standby,
          setText: model.setTarget,
          lines:4
        ),
        const SizedBox(height: 12),

        // Скрытый
        const ProjectEditHidden()
      ],
    );
  }

  Future _save(Future<bool> Function() save) async {
    if (!_formKey.currentState!.validate()) return;
    var result = await save();
    if (mounted) {
      Navigator.pop(context, result);
    }
  }

  void _close() {
    if (context.mounted) {
      Navigator.pop(context);
    }
  }

  Future _delete(Future Function() delete) async {
    if (await showConfirmDialog(context) == true && context.mounted) {
      await delete();
      _close();
    }
  }
}
