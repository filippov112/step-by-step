import 'package:chaos_control/models/project.dart';
import 'package:chaos_control/screens/targets/create/target_create_model.dart';
import 'package:chaos_control/screens/targets/create/widgets/favorite.dart';
import 'package:chaos_control/screens/targets/create/widgets/info.dart';
import 'package:chaos_control/widgets/dialogs/bottom_modal_form.dart';
import 'package:flutter/material.dart';
import 'package:chaos_control/widgets/form/text_input.dart';
import 'package:provider/provider.dart';

class TargetCreateScreen extends StatefulWidget {
  final Project? project;
  final String group;
  const TargetCreateScreen({
    super.key,
    required this.project,
    required this.group,
  });

  @override
  State<TargetCreateScreen> createState() => _TargetCreateScreenState();
}

class _TargetCreateScreenState extends State<TargetCreateScreen> {
  final _formKey = GlobalKey<FormState>();
  late TargetCreateModel model;
  late TextEditingController titleController, targetController;

  @override
  void initState() {
    super.initState();
    model = context.read<TargetCreateModel>();
    model.group = widget.group;
    titleController = TextEditingController();
    targetController = TextEditingController();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      model.setTarget(widget.project);
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
    final group = context.select<TargetCreateModel, String>((m) => m.group);

    return BottomModalForm(
      title: 'Новая цель',
      confirmCallback: () => _save(saveTask),
      formKey: _formKey,
      children: [
        // Проект и группа
        const TargetCreateInfo(),

        Row(
          children: [
            // Название
            Expanded(
              child: CustomTextInput(
                requiredErrorText: 'Введите название',
                header: 'Название',
                setText: model.setTitle,
                icon: Icons.title,
                controller: titleController,
              ),
            ),
            const SizedBox(width: 8),
            // Избранная
            const TargetCreateFavorite(),
          ],
        ),
        const SizedBox(height: 6),

        // Цель
        CustomTextInput(
          header: 'Цель',
          setText: model.setDesc,
          icon: Icons.center_focus_weak_rounded,
          controller: targetController,
          lines: 4,
        ),
        const SizedBox(height: 12),

        // Группа
        CustomTextInput(
          header: 'Группа',
          initialValue: group,
          setText: model.setGroup,
          icon: Icons.folder,
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
