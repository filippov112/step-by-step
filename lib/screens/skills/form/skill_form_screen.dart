import 'package:flutter/material.dart';
import 'package:chaos_control/models/skill.dart';
import 'package:chaos_control/screens/skills/form/skill_form_model.dart';
import 'package:chaos_control/screens/skills/form/widgets/conditions.dart';
import 'package:chaos_control/screens/skills/form/widgets/description.dart';
import 'package:chaos_control/screens/skills/form/widgets/icon.dart';
import 'package:chaos_control/screens/skills/form/widgets/rang.dart';
import 'package:chaos_control/screens/skills/form/widgets/tags.dart';
import 'package:chaos_control/screens/skills/list/skill_list_model.dart';
import 'package:chaos_control/widgets/dialogs/confirm_dialog.dart';
import 'package:chaos_control/widgets/form/singleline_input.dart';
import 'package:chaos_control/widgets/screens/entity_screen.dart';
import 'package:provider/provider.dart';
import 'package:chaos_control/models/enums/skill_rang.dart';

class SkillFormScreen extends StatefulWidget {
  final Skill? skill;

  const SkillFormScreen({super.key, this.skill});

  @override
  State<SkillFormScreen> createState() => _SkillFormScreenState();
}

class _SkillFormScreenState extends State<SkillFormScreen> {
  final _formKey = GlobalKey<FormState>();
  late SkillFormModel model;
  late TextEditingController titleController;
  final Map<SkillRang, TextEditingController> descControllers = {};

  @override
  void initState() {
    super.initState();
    model = context.read<SkillFormModel>();
    titleController = TextEditingController(text: widget.skill?.title);
    descControllers[SkillRang.F] = TextEditingController(
      text: widget.skill?.f ?? '',
    );
    descControllers[SkillRang.E] = TextEditingController(
      text: widget.skill?.e ?? '',
    );
    descControllers[SkillRang.D] = TextEditingController(
      text: widget.skill?.d ?? '',
    );
    descControllers[SkillRang.C] = TextEditingController(
      text: widget.skill?.c ?? '',
    );
    descControllers[SkillRang.B] = TextEditingController(
      text: widget.skill?.b ?? '',
    );
    descControllers[SkillRang.A] = TextEditingController(
      text: widget.skill?.a ?? '',
    );
    descControllers[SkillRang.S] = TextEditingController(
      text: widget.skill?.s ?? '',
    );
    descControllers[SkillRang.SS] = TextEditingController(
      text: widget.skill?.ss ?? '',
    );
    descControllers[SkillRang.SSS] = TextEditingController(
      text: widget.skill?.sss ?? '',
    );
    descControllers[SkillRang.EX] = TextEditingController(
      text: widget.skill?.ex ?? '',
    );

    WidgetsBinding.instance.addPostFrameCallback((_) {
      model.loadData(widget.skill);
    });
  }

  @override
  void dispose() {
    titleController.dispose();
    for (var controller in descControllers.values) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return EntityScreen(
      title: 'Навык',
      formKey: _formKey,
      deleteCallback: widget.skill != null
          ? () => _confirmDelete(context)
          : null,
      saveCallback: () => _saveSkill(context),
      children: [
        // Иконка
        const SkillFormIcon(),
        const SizedBox(height: 12),

        // Название
        SinglelineInput(
          header: 'Название',
          controller: titleController,
          requiredErrorText: 'Введите название',
          setText: model.setTitle,
        ),
        const SizedBox(height: 12),

        // Ранг
        const SkillFormRang(),
        const SizedBox(height: 12),

        // Описания для рангов
        SkillFormDescriptions(descControllers: descControllers),
        const SizedBox(height: 12),

        // Теги
        const SkillFormTags(),
        const SizedBox(height: 12),

        // Условия
        const SkillFormConditions(),
      ],
    );
  }

  Future<void> _saveSkill(BuildContext context) async {
    if (!mounted || _formKey.currentState == null) return;
    if (!(_formKey.currentState?.validate() ?? false)) return;

    final success = await model.saveSkill();
    if (!mounted) return;

    if (success && context.mounted) {
      Navigator.pop(context, true);
    } else {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(model.error ?? 'Ошибка сохранения'),
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        );
      }
    }
  }

  Future _confirmDelete(BuildContext context) async {
    if (await showConfirmDialog(context) == true &&
        context.mounted &&
        widget.skill != null) {
      await context.read<SkillListModel>().deleteSkill(widget.skill!.id);
      if (context.mounted) {
        Navigator.pop(context, true);
      }
    }
  }
}
