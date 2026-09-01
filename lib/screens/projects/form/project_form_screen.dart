import 'package:chaos_control/screens/projects/form/widgets/hidden.dart';
import 'package:chaos_control/widgets/common/custom_card_block.dart';
import 'package:chaos_control/widgets/common/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:chaos_control/models/project.dart';
import 'package:chaos_control/screens/projects/form/widgets/icon.dart';
import 'package:chaos_control/widgets/form/text_input.dart';
import 'package:chaos_control/screens/projects/form/project_form_model.dart';
import 'package:chaos_control/widgets/dialogs/confirm_dialog.dart';
import 'package:chaos_control/widgets/screens/entity_screen.dart';
import 'package:provider/provider.dart';

class ProjectFormScreen extends StatefulWidget {
  final Project? project;

  const ProjectFormScreen({super.key, this.project});

  @override
  State<ProjectFormScreen> createState() => _ProjectFormScreenState();
}

class _ProjectFormScreenState extends State<ProjectFormScreen> {
  final _formKey = GlobalKey<FormState>();
  late ProjectFormModel model;
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
    model = context.read<ProjectFormModel>();
    titleController = TextEditingController(text: widget.project?.title);
    targetController = TextEditingController(text: widget.project?.target);
    groupController = TextEditingController(text: widget.project?.group ?? '/');
    WidgetsBinding.instance.addPostFrameCallback((_) {
      model.setClass(widget.project);
    });
  }

  @override
  Widget build(BuildContext context) {
    var save = model.save;
    var delete = model.delete;

    return EntityScreen(
      title: 'Проект',
      saveCallback: () => _save(save),
      deleteCallback: widget.project == null ? null : () => _delete(delete),
      formKey: _formKey,
      children: [
        // Иконка
        const ProjectFormIcon(),
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

        const ProjectFormHidden()
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
