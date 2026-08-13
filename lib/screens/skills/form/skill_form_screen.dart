// lib/screens/skills/skill_form_screen.dart
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:life_game/models/skill.dart';
import 'package:life_game/screens/skills/form/skill_form_model.dart';
import 'package:life_game/screens/skills/form/widgets/condition_dialog.dart';
import 'package:life_game/screens/skills/list/widgets/tags_modal_widget.dart';
import 'package:life_game/themes/solo_leveling_theme.dart';
import 'package:life_game/widgets/common/tag_chip.dart';
import 'package:provider/provider.dart';
import 'package:life_game/models/enums/skill_rang.dart';

class SkillFormScreen extends StatefulWidget {
  final Skill? skill;
  
  const SkillFormScreen({super.key, this.skill});

  @override
  State<SkillFormScreen> createState() => _SkillFormScreenState();
}

class _SkillFormScreenState extends State<SkillFormScreen> {
  late SkillFormModel _viewModel;

  @override
  void initState() {
    super.initState();
    _viewModel = SkillFormModel();
    _initializeForm();
  }

  Future<void> _initializeForm() async {
    if (widget.skill != null) {
      await _viewModel.loadSkillForEditing(widget.skill!);
    } else {
      await _viewModel.loadTags();
    }
  }

  @override
  void dispose() {
    _viewModel.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: _viewModel,
      child: Scaffold(
        appBar: AppBar(
          title: Text(widget.skill == null ? 'Создание навыка' : 'Редактирование навыка'),
          actions: [
            if (widget.skill != null)
              IconButton(
                icon: const Icon(Icons.delete_outline),
                onPressed: () => _confirmDelete(context),
                tooltip: 'Удалить',
              ),
          ],
        ),
        body: Consumer<SkillFormModel>(
          builder: (context, viewModel, child) {
            if (viewModel.isLoading) {
              return const Center(child: CircularProgressIndicator());
            }
            
            return SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Иконка
                  _buildIconPicker(viewModel),
                  const SizedBox(height: 16),
                  
                  if (viewModel.iconPath.isNotEmpty) ...{
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () => _deleteIcon(viewModel), 
                        child: Text('Удалить иконку')
                      ),
                    ),
                    const SizedBox(height: 16),
                  },

                  // Название
                  TextFormField(
                    decoration: const InputDecoration(
                      labelText: 'Название навыка',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.title),
                    ),
                    initialValue: viewModel.title,
                    onChanged: viewModel.setTitle,
                  ),
                  const SizedBox(height: 16),
                  
                  // Ранг
                  DropdownButtonFormField<SkillRang>(
                    decoration: const InputDecoration(
                      labelText: 'Ранг',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.arrow_upward),
                    ),
                    initialValue: viewModel.rang,
                    items: SkillRang.values.map((rang) {
                      return DropdownMenuItem(
                        value: rang,
                        child: Text(rang.name),
                      );
                    }).toList(),
                    onChanged: (value) {
                      if (value != null) viewModel.setRang(value);
                    },
                  ),
                  const SizedBox(height: 16),
                  
                  // Уровень и опыт
                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          decoration: const InputDecoration(
                            labelText: 'Уровень',
                            border: OutlineInputBorder(),
                            prefixIcon: Icon(Icons.numbers),
                          ),
                          keyboardType: TextInputType.number,
                          initialValue: viewModel.level.toString(),
                          onChanged: (val) {
                            final value = int.tryParse(val);
                            if (value != null) viewModel.setLevel(value);
                          },
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: TextFormField(
                          decoration: const InputDecoration(
                            labelText: 'Опыт',
                            border: OutlineInputBorder(),
                            prefixIcon: Icon(Icons.star),
                          ),
                          keyboardType: TextInputType.number,
                          initialValue: viewModel.experience.toString(),
                          onChanged: (val) {
                            final value = int.tryParse(val);
                            if (value != null) viewModel.setExperience(value);
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  
                  // Описания для рангов
                  const Text(
                    'Описания для рангов',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  ...SkillRang.values.map((rang) {
                    return _buildDescriptionField(viewModel, rang);
                  }),
                  
                  const SizedBox(height: 24),
                  
                  // Теги с кнопкой выбора
                  _buildTagsSelector(viewModel),
                  
                  const SizedBox(height: 24),
                  
                  // Условия
                  ConditionsListWidget(
                    conditions: viewModel.conditions,
                    onAdd: viewModel.addCondition,
                    onEdit: viewModel.updateCondition,
                    onDelete: viewModel.removeCondition,
                  ),
                  
                  if (viewModel.error != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 16),
                      child: Text(
                        viewModel.error!,
                        style: const TextStyle(color: Colors.red),
                      ),
                    ),
                  
                  const SizedBox(height: 24),
                  
                  // Кнопки
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: viewModel.isSaving ? null : () => Navigator.pop(context, false),
                          child: const Text('Отмена'),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: viewModel.isSaving ? null : () => _saveSkill(context),
                          child: viewModel.isSaving
                              ? const SizedBox(
                                  height: 20,
                                  width: 20,
                                  child: CircularProgressIndicator(strokeWidth: 2),
                                )
                              : Text(widget.skill == null ? 'Создать' : 'Сохранить'),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildTagsSelector(SkillFormModel viewModel) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Теги',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            ElevatedButton.icon(
              onPressed: () => _showTagsModal(context),
              icon: const Icon(Icons.edit, size: 18),
              label: Text(
                viewModel.selectedTags.isEmpty ? 'Выбрать' : 'Изменить',
              ),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        if (viewModel.selectedTags.isEmpty)
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: SoloLevelingTheme.steelBlue),
            ),
            child: const Center(
              child: Text(
                'Теги не выбраны',
                style: TextStyle(color: SoloLevelingTheme.steelBlue),
              ),
            ),
          )
        else
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: viewModel.selectedTags.map((tag) {
              return TagChip(title: tag.title);
            }).toList(),
          ),
        if (viewModel.selectedTags.isNotEmpty) ...[
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.all(8),
            child: Row(
              children: [
                Icon(Icons.info_outline, size: 16),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Выбрано тегов: ${viewModel.selectedTags.length}',
                    style: TextStyle(
                      fontSize: 12,
                    ),
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
      allTags: _viewModel.allTags,
      selectedTags: _viewModel.selectedTags,
    );
    
    if (result != null) {
      // Очищаем текущие теги
      for (var tag in _viewModel.selectedTags.toList()) {
        _viewModel.toggleTag(tag);
      }
      // Добавляем новые теги
      for (var tag in result) {
        _viewModel.toggleTag(tag);
      }
    }
  }

  Widget _buildIconPicker(SkillFormModel viewModel) {
    return GestureDetector(
      onTap: () => _pickIcon(viewModel),
      child: Container(
        width: double.infinity,
        height: 120,
        decoration: BoxDecoration(
          // border: Border.all(
          //   color: Colors.grey.shade300
          //   ),
          borderRadius: BorderRadius.circular(12),
          color: SoloLevelingTheme.steelBlue.withAlpha(80),
        ),
        child: viewModel.iconPath.isEmpty
            ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.add_a_photo, size: 48, 
                    color: SoloLevelingTheme.paleBlue
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Нажмите для выбора иконки',
                    style: TextStyle(color: SoloLevelingTheme.paleBlue),
                  ),
                ],
              )
            : ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    Image.file(
                      File(viewModel.iconPath),
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.broken_image, size: 48, color: SoloLevelingTheme.paleBlue),
                            const SizedBox(height: 8),
                            Text(
                              'Ошибка загрузки',
                              style: TextStyle(color: SoloLevelingTheme.paleBlue),
                            ),
                          ],
                        );
                      },
                    ),

                    Positioned(
                      top: 8,
                      right: 8,
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: Colors.black.withValues(alpha: 0.6),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: const Icon(
                          Icons.edit,
                          color: Colors.white,
                          size: 20,
                        ),
                      ),
                    ),

                  ],
                ),
              ),
      ),
    );
  }

  Widget _buildDescriptionField(SkillFormModel viewModel, SkillRang rang) {
    final description = viewModel.getDescriptionForRang(rang);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: TextFormField(
        decoration: InputDecoration(
          labelText: 'Описание для ранга ${rang.name}',
          border: const OutlineInputBorder(),
          prefixIcon: Container(
            width: 40,
            margin: const EdgeInsets.fromLTRB(12,0,8,0),
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
        initialValue: description ?? '',
        onChanged: (val) {
          viewModel.setDescription(rang, val);
        },
      ),
    );
  }

  Future<void> _pickIcon(SkillFormModel viewModel) async {
    await viewModel.pickIcon();
  }

  Future<void> _deleteIcon(SkillFormModel viewModel) async {
    await viewModel.deleteIcon();
  }

  Future<void> _saveSkill(BuildContext context) async {
    final success = await _viewModel.saveSkill();
    if (!mounted) return;
    
    if (success && context.mounted) {
      Navigator.pop(context, true);
    } else {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(_viewModel.error ?? 'Ошибка сохранения'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  void _confirmDelete(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Удаление навыка'),
        content: const Text('Вы уверены, что хотите удалить этот навык?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Отмена'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context, true);
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Удалить'),
          ),
        ],
      ),
    );
  }
}