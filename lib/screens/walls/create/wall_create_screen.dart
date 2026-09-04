import 'package:chaos_control/models/project.dart';
import 'package:chaos_control/screens/walls/create/wall_create_model.dart';
import 'package:chaos_control/screens/walls/create/widgets/difficulty.dart';
import 'package:chaos_control/screens/walls/create/widgets/favorite.dart';
import 'package:chaos_control/screens/walls/create/widgets/info.dart';
import 'package:chaos_control/screens/walls/create/widgets/status.dart';
import 'package:chaos_control/widgets/dialogs/bottom_modal_form.dart';
import 'package:flutter/material.dart';
import 'package:chaos_control/models/wall.dart';
import 'package:chaos_control/widgets/form/text_input.dart';
import 'package:provider/provider.dart';

class WallCreateScreen extends StatefulWidget {
  final Wall? parent;
  final Project? project;
  final String group;
  const WallCreateScreen({
    super.key,
    this.parent,
    required this.project,
    required this.group,
  });

  @override
  State<WallCreateScreen> createState() => _WallCreateScreenState();
}

class _WallCreateScreenState extends State<WallCreateScreen> {
  final _formKey = GlobalKey<FormState>();
  late WallCreateModel model;
  late TextEditingController titleController, groupController, targetController;

  @override
  void initState() {
    super.initState();
    model = context.read<WallCreateModel>();
    titleController = TextEditingController();
    targetController = TextEditingController();
    groupController = TextEditingController();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      model.setWall(widget.project, widget.group);
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

    return BottomModalForm(
      title: 'Новая стена',
      confirmCallback: () => _save(saveTask),
      formKey: _formKey,
      children: [
        // Проект и группа
        const WallCreateInfo(),

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
            const WallCreateFavorite(),
          ],
        ),
        const SizedBox(height: 6),
        
        // Цель
        CustomTextInput(
          header: 'Цель',
          setText: model.setTarget,
          icon: Icons.center_focus_weak_rounded,
          controller: targetController,
          lines: 4,
        ),
        const SizedBox(height: 12),

        // Сложность
        const WallCreateDifficulty(),
        const SizedBox(height: 12),

        // Статус
        const WallCreateStatus(),
      ],
    );
  }

  Future _save(Future<bool> Function() wall) async {
    if (!mounted || _formKey.currentState == null) return;
    if (!(_formKey.currentState?.validate() ?? false)) return;

    var result = await wall();
    if (mounted) {
      Navigator.pop(context, result);
    }
  }
}
