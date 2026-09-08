import 'package:chaos_control/screens/projects/create/project_create_model.dart';
import 'package:chaos_control/screens/projects/create/widgets/hidden.dart';
import 'package:chaos_control/screens/projects/create/widgets/icon.dart';
import 'package:chaos_control/widgets/dialogs/bottom_modal_form.dart';
import 'package:flutter/material.dart';
import 'package:chaos_control/widgets/form/text_input.dart';
import 'package:provider/provider.dart';

class ProjectCreateScreen extends StatefulWidget {
  final String group;
  const ProjectCreateScreen({super.key, required this.group});

  @override
  State<ProjectCreateScreen> createState() => _ProjectCreateScreenState();
}

class _ProjectCreateScreenState extends State<ProjectCreateScreen> {
  final _formKey = GlobalKey<FormState>();
  late ProjectCreateModel model;
  late TextEditingController titleController, targetController;

  @override
  void initState() {
    super.initState();
    model = context.read<ProjectCreateModel>();
    model.group = widget.group;
    titleController = TextEditingController();
    targetController = TextEditingController();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      model.setProject();
    });
  }

  @override
  void dispose() {
    titleController.dispose();
    targetController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final saveTask = model.save;
    final group = context.select<ProjectCreateModel, String>((m) => m.group);

    final nameField = CustomTextInput(
      requiredErrorText: 'Введите название',
      header: 'Название',
      controller: titleController,
      icon: Icons.title,
      setText: model.setTitle,
    );
    final groupField = CustomTextInput(
      header: 'Группа',
      initialValue: group,
      icon: Icons.folder,
      setText: model.setGroup,
      lines: 1,
      customValidator: model.groupValidator,
    );
    final targetField = CustomTextInput(
      header: 'Цель',
      controller: targetController,
      icon: Icons.mode_standby,
      setText: model.setTarget,
      lines: 4,
    );

    return BottomModalForm(
      title: 'Проект',
      confirmCallback: () => _save(saveTask),
      formKey: _formKey,
      children: [
        Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Название
                  nameField,
                  const SizedBox(height: 12),

                  // Группа
                  groupField,
                ],
              ),
            ),

            // Иконка
            Padding(
              padding: const EdgeInsetsGeometry.all(8),
              child: const ProjectCreateIcon(),
            ),
          ],
        ),
        const SizedBox(height: 12),

        Row(
          children: [
            // Цель
            Expanded(
              child: targetField,
            ),
            // Скрытый
            Padding(
              padding: const EdgeInsetsGeometry.all(8),
              child: const ProjectCreateHidden(),
            ),
          ],
        ),
      ],
    );
  }

  Future _save(Future<bool> Function() target) async {
    if (!mounted || _formKey.currentState == null) return;
    if (!(_formKey.currentState?.validate() ?? false)) return;

    var result = await target();
    if (mounted) {
      Navigator.pop(context, result);
    }
  }
}
