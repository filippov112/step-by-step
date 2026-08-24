import 'package:flutter/material.dart';
import 'package:life_game/models/achievement.dart';
import 'package:life_game/screens/achievements/form/achievement_form_model.dart';
import 'package:life_game/screens/achievements/form/widgets/date.dart';
import 'package:life_game/widgets/form/multiline_input.dart';
import 'package:life_game/screens/achievements/form/widgets/icon.dart';
import 'package:life_game/screens/achievements/form/widgets/rarity.dart';
import 'package:life_game/screens/achievements/form/widgets/tags.dart';
import 'package:life_game/widgets/form/singleline_input.dart';
import 'package:life_game/widgets/dialogs/confirm_dialog.dart';
import 'package:life_game/widgets/screens/entity_screen.dart';
import 'package:provider/provider.dart';

class AchievementFormScreen extends StatefulWidget {
  final Achievement? achi;

  const AchievementFormScreen({super.key, this.achi});

  @override
  State<AchievementFormScreen> createState() => _AchievementFormScreenState();
}

class _AchievementFormScreenState extends State<AchievementFormScreen> {
  final _formKey = GlobalKey<FormState>();
  late AchievementFormModel model;
  late TextEditingController titleController;
  late TextEditingController descController;

  @override
  void dispose() {
    titleController.dispose();
    descController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    model = context.read<AchievementFormModel>();
    titleController = TextEditingController();
    descController = TextEditingController();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      model.setAchievement(widget.achi);
      titleController.text = widget.achi?.title ?? '';
      descController.text = widget.achi?.description ?? '';
    });
  }

  @override
  Widget build(BuildContext context) {
    final saveAchievement = model.saveAchievement;
    final deleteAchievement = model.deleteAchievement;

    return EntityScreen(
      title: 'Достижение',
      formKey: _formKey,
      saveCallback: () => _saveAchievement(saveAchievement),
      deleteCallback: widget.achi == null
          ? () {}
          : () => _delete(deleteAchievement),
      children: [
        // Иконка
        const AchievFormIcon(),
        const SizedBox(height: 12),

        // Название
        SinglelineInput(
          requiredErrorText: 'Введите название',
          header: 'Название',
          controller: titleController,
          setText: model.setTitle,
        ),
        const SizedBox(height: 12),

        // Описание
        CustomMultilineTextInput(
          header: 'Описание',
          controller: descController,
          setText: model.setDescription,
        ),
        const SizedBox(height: 12),

        // Дата
        const AchievFormDate(),
        const SizedBox(height: 12),

        // Редкость
        const AchievFormRarity(),
        const SizedBox(height: 12),

        // Теги
        const AchievFormTags(),
      ],
    );
  }

  Future _saveAchievement(Future<bool> Function() saveAchievement) async {
    if (!_formKey.currentState!.validate()) return;
    var result = await saveAchievement();
    if (mounted) {
      Navigator.pop(context, result);
    }
  }

  Future _delete(Future Function() deleteAchievement) async {
    if (await showConfirmDialog(context) == true && context.mounted) {
      await deleteAchievement();
      if (context.mounted) {
        Navigator.pop(context);
      }
    }
  }
}
