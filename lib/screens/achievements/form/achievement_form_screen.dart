import 'package:flutter/material.dart';
import 'package:life_game/models/achievement.dart';
import 'package:life_game/models/enums/achiev_rar.dart';
import 'package:life_game/models/tag.dart';
import 'package:life_game/screens/achievements/form/achievement_form_model.dart';
import 'package:life_game/screens/achievements/form/widgets/buttons.dart';
import 'package:life_game/screens/achievements/form/widgets/date.dart';
import 'package:life_game/screens/achievements/form/widgets/description.dart';
import 'package:life_game/widgets/dialogs/custom_icon_picker.dart';
import 'package:life_game/screens/achievements/form/widgets/rarity.dart';
import 'package:life_game/screens/achievements/form/widgets/tags.dart';
import 'package:life_game/screens/achievements/form/widgets/title.dart';
import 'package:life_game/widgets/common/confirm_dialog.dart';
import 'package:life_game/widgets/common/entity_appbar.dart';
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
  TextEditingController? titleController;
  TextEditingController? descController;

  @override
  void dispose() {
    titleController?.dispose();
    descController?.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    model = context.read<AchievementFormModel>();
    model.setAchievement(widget.achi);

    var selectedDescription = model.selectedDescription;
    var selectedTitle = model.selectedTitle;
    titleController = TextEditingController(text: selectedTitle);
    descController = TextEditingController(text: selectedDescription);
  }

  @override
  Widget build(BuildContext context) {
    var isEditing = context.select<AchievementFormModel, bool>(
      (model) => model.isEditing,
    );
    var selectedIcon = context.select<AchievementFormModel, String?>(
      (model) => model.selectedIcon,
    );
    var selectedDate = context.select<AchievementFormModel, DateTime?>(
      (model) => model.selectedDate,
    );
    var selectedRarity = context.select<AchievementFormModel, AchievRar>(
      (model) => model.selectedRarity,
    );
    var selectedTags = context.select<AchievementFormModel, List<Tag>>(
      (model) => model.selectedTags,
    );

    var setIcon = model.setIcon;
    var setRarity = model.setRarity;
    var setDate = model.setDate;
    var setSelectedTags = model.setSelectedTags;

    var saveAchievement = model.saveAchievement;
    var deleteAchievement = model.deleteAchievement;

    return Scaffold(
      appBar: buildAppBar(
        'Достижение',
        deleteCallback: () => _delete(deleteAchievement),
      ),
      body: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: [

                  // Иконка
                  Center(
                    child: CustomIconPicker(
                      iconPath: selectedIcon,
                      setIcon: setIcon,
                      borderWidth: 3,
                      color: selectedRarity.color
                    ),
                  ),

                  const SizedBox(height: 8),
                  const Divider(),
                  const SizedBox(height: 8),

                  Text(
                    'Основные поля',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  SizedBox(height: 12),

                  // Название
                  buildTitleInput(controller: titleController),
                  const SizedBox(height: 12),

                  // Описание
                  buildDescriptionInput(controller: descController),
                  const SizedBox(height: 12),

                  // Дата
                  buildDatePicker(
                    context,
                    currentDatetime: selectedDate,
                    setDateTime: setDate,
                  ),

                  const SizedBox(height: 8),
                  const Divider(),
                  const SizedBox(height: 8),

                  // Редкость
                  buildRaritySelector(
                    context,
                    currentRarity: selectedRarity,
                    setRarity: setRarity,
                  ),

                  const SizedBox(height: 8),
                  const Divider(),
                  const SizedBox(height: 8),

                  // Теги
                  buildTagsSection(
                    context,
                    selectedTags: selectedTags,
                    setSelectedTags: setSelectedTags,
                  ),

                  const SizedBox(height: 8),
                ],
              ),
            ),
            // Кнопки
            buildButtonsBlock(
              context,
              saveCallback: () => _saveAchievement(saveAchievement),
              isEditing: isEditing,
            ),
          ],
        ),
      ),
    );
  }

  Future _saveAchievement(Future<bool> Function() saveAchievement) async {
    if (!_formKey.currentState!.validate()) return;
    model.setTitle(titleController?.text ?? '');
    model.setDescription(descController?.text ?? '');
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
