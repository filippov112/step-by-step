import 'package:flutter/material.dart';
import 'package:life_game/models/skill.dart';
import 'package:life_game/screens/skills/form/skill_form_model.dart';
import 'package:life_game/screens/skills/form/widgets/condition_dialog.dart';
import 'package:life_game/screens/skills/list/skill_list_model.dart';
import 'package:life_game/screens/skills/list/widgets/tags_modal_widget.dart';
import 'package:life_game/widgets/dialogs/confirm_dialog.dart';
import 'package:life_game/widgets/common/custom_text.dart';
import 'package:life_game/widgets/common/tag_chip.dart';
import 'package:life_game/widgets/form/custom_icon_picker.dart';
import 'package:provider/provider.dart';
import 'package:life_game/models/enums/skill_rang.dart';

class SkillFormScreen extends StatefulWidget {
  final Skill? skill;

  const SkillFormScreen({super.key, this.skill});

  @override
  State<SkillFormScreen> createState() => _SkillFormScreenState();
}

class _SkillFormScreenState extends State<SkillFormScreen> {
  SkillFormModel? model;
  late TextEditingController titleController;
  final List<TextEditingController> descControllers = [];

  @override
  void initState() {
    super.initState();
    model = context.read<SkillFormModel>();
    titleController = TextEditingController(text: widget.skill?.title);
    descControllers.add(TextEditingController(text:widget.skill?.f ?? ''));
    descControllers.add(TextEditingController(text:widget.skill?.e ?? ''));
    descControllers.add(TextEditingController(text:widget.skill?.d ?? ''));
    descControllers.add(TextEditingController(text:widget.skill?.c ?? ''));
    descControllers.add(TextEditingController(text:widget.skill?.b ?? ''));
    descControllers.add(TextEditingController(text:widget.skill?.a ?? ''));
    descControllers.add(TextEditingController(text:widget.skill?.s ?? ''));
    descControllers.add(TextEditingController(text:widget.skill?.ss ?? ''));
    descControllers.add(TextEditingController(text:widget.skill?.sss ?? ''));
    descControllers.add(TextEditingController(text:widget.skill?.ex ?? ''));
    
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (widget.skill != null) {
        model?.loadSkillForEditing(widget.skill!);
      } else {
        model?.loadTags();
      }
    });
  }

  @override
  void dispose() {
    titleController.dispose();
    for(var controller in descControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final iconPath = context.select<SkillFormModel, String?>(
      (model) => model.iconPath,
    );
    final setIcon = model?.setIcon ?? (_) {};
    final setTitle = model?.setTitle ?? (_) {};
    final rang = context.select<SkillFormModel, SkillRang>(
      (model) => model.rang,
    );
    final setRang = model?.setRang ?? (_) {};

    return Scaffold(
      appBar: AppBar(
        title: const CustomText('Навык'),
        actions: [
          if (widget.skill != null)
            IconButton(
              icon: const Icon(Icons.delete_outline),
              onPressed: () => _confirmDelete(context),
              tooltip: 'Удалить',
            ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: ListView(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Иконка
                      const SizedBox(height: 16),
                      CustomIconPicker(
                        iconPath: iconPath,
                        setIcon: setIcon,
                        borderWidth: 3,
                        color: rang.color,
                      ),
                      const SizedBox(height: 16),

                      // Название
                      TextFormField(
                        controller: titleController,
                        decoration: const InputDecoration(
                          labelText: 'Название навыка',
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.title),
                        ),
                        onChanged: setTitle,
                      ),
                      const SizedBox(height: 16),

                      // Ранг
                      DropdownButtonFormField<SkillRang>(
                        decoration: const InputDecoration(
                          labelText: 'Ранг',
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.arrow_upward),
                        ),
                        initialValue: rang,
                        items: SkillRang.values.map((rang) {
                          return DropdownMenuItem(
                            value: rang,
                            child: Text(rang.name),
                          );
                        }).toList(),
                        onChanged: (value) {
                          if (value != null) setRang(value);
                        },
                      ),
                      const SizedBox(height: 16),

                      // Описания для рангов
                      const CustomText(
                        'Описания для рангов',
                        size: 18,
                        weight: FontWeight.bold,
                      ),
                      const SizedBox(height: 8),
                      Container(
                        height: 200,
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          borderRadius: const BorderRadius.all(
                            Radius.circular(8),
                          ),
                          border: Border.all(
                            color: Theme.of(context).dividerColor,
                          ),
                        ),
                        child: ListView(
                          children: [
                            ...SkillRang.values.map((rang) {
                              return _buildDescriptionField(rang, descControllers[rang.index]);
                            }),
                          ],
                        ),
                      ),

                      const SizedBox(height: 24),

                      // Теги с кнопкой выбора
                      _buildTagsSelector(),

                      const SizedBox(height: 24),

                      // Условия
                      ConditionsListWidget(
                        conditions: model?.conditions ?? [],
                        onAdd: model?.addCondition ?? (_) {},
                        onEdit: model?.updateCondition ?? (_, _) {},
                        onDelete: model?.removeCondition ?? (_) {},
                      ),

                      if (model?.error != null)
                        Padding(
                          padding: const EdgeInsets.only(top: 16),
                          child: Text(
                            model?.error ?? '',
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.error,
                            ),
                          ),
                        ),

                      const SizedBox(height: 24),
                    ],
                  ),
                ],
              ),
            ),
          ),

          // Кнопки
          Padding(
            padding: const EdgeInsetsGeometry.all(16),
            child: Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: model?.isSaving ?? false
                        ? null
                        : () => Navigator.pop(context, false),
                    child: const CustomText('Отмена'),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton(
                    onPressed: model?.isSaving ?? false
                        ? null
                        : () => _saveSkill(context),
                    child: model?.isSaving ?? false
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const CustomText('Сохранить'),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTagsSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const CustomText('Теги', size: 18, weight: FontWeight.bold),
            IconButton(
              onPressed: () => _showTagsModal(context),
              icon: const Icon(Icons.add, size: 18),
            ),
          ],
        ),
        const SizedBox(height: 8),
        if (model == null || model!.selectedTags.isEmpty)
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Theme.of(context).dividerColor),
            ),
            child: Center(
              child: CustomText(
                'Теги не выбраны',
                color: Theme.of(context).dividerColor,
              ),
            ),
          )
        else
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children:
                model?.selectedTags.map((tag) {
                  return TagChip(title: tag.title);
                }).toList() ??
                [],
          ),
        if (model != null && model!.selectedTags.isNotEmpty) ...[
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.all(8),
            child: Row(
              children: [
                Icon(Icons.info_outline, size: 16),
                const SizedBox(width: 8),
                Expanded(
                  child: CustomText(
                    'Выбрано тегов: ${model?.selectedTags.length ?? 0}',
                    size: 12,
                  ),
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }

  Future<void> _showTagsModal(BuildContext context) async {
    final result = await showTagsModal(
      context,
      allTags: model?.allTags ?? [],
      selectedTags: model?.selectedTags ?? [],
    );

    if (result != null) {
      // Очищаем текущие теги
      for (var tag in model?.selectedTags.toList() ?? []) {
        model?.toggleTag(tag);
      }
      // Добавляем новые теги
      for (var tag in result) {
        model?.toggleTag(tag);
      }
    }
  }

  Widget _buildDescriptionField(SkillRang rang, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          labelText: 'Описание для ранга ${rang.name}',
          border: const OutlineInputBorder(),
          prefixIcon: Container(
            width: 40,
            margin: const EdgeInsets.fromLTRB(12, 0, 8, 0),
            decoration: BoxDecoration(
              color: rang.color.withValues(alpha: 0.2),
              borderRadius: const BorderRadius.all(Radius.circular(8)),
            ),
            child: Center(
              child: Text(
                rang.name,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: rang.color,
                  fontSize: 12,
                ),
              ),
            ),
          ),
        ),
        maxLines: 2,
        onChanged: (val) {
          model?.setDescription(rang, val);
        },
      ),
    );
  }

  Future<void> _saveSkill(BuildContext context) async {
    final success = await model?.saveSkill() ?? false;
    if (!mounted) return;

    if (success && context.mounted) {
      Navigator.pop(context, true);
    } else {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(model?.error ?? 'Ошибка сохранения'),
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
