import 'dart:io';
import 'package:flutter/material.dart';
import 'package:life_game/models/skill.dart';
import 'package:life_game/screens/skills/form/skill_form_model.dart';
import 'package:life_game/screens/skills/form/widgets/condition_dialog.dart';
import 'package:life_game/screens/skills/form/widgets/tags_selector_widget.dart';
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
                  
                  // Теги
                  TagsSelectorWidget(
                    allTags: viewModel.allTags,
                    selectedTags: viewModel.selectedTags,
                    onToggleTag: viewModel.toggleTag,
                  ),
                  
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

  Widget _buildIconPicker(SkillFormModel viewModel) {
    return GestureDetector(
      onTap: () => _pickIcon(viewModel),
      child: Container(
        width: double.infinity,
        height: 120,
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade300),
          borderRadius: BorderRadius.circular(12),
          color: Colors.grey.shade50,
        ),
        child: viewModel.iconPath.isEmpty
            ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.add_a_photo, size: 48, color: Colors.grey.shade400),
                  const SizedBox(height: 8),
                  Text(
                    'Нажмите для выбора иконки',
                    style: TextStyle(color: Colors.grey.shade600),
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
                            Icon(Icons.broken_image, size: 48, color: Colors.grey.shade400),
                            const SizedBox(height: 8),
                            Text(
                              'Ошибка загрузки',
                              style: TextStyle(color: Colors.grey.shade600),
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
            margin: const EdgeInsets.only(right: 8),
            decoration: BoxDecoration(
              color: _getRangColor(rang).withValues(alpha: 0.2),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(4),
                bottomLeft: Radius.circular(4),
              ),
            ),
            child: Center(
              child: Text(
                rang.name,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: _getRangColor(rang),
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

  Color _getRangColor(SkillRang rang) {
    switch (rang) {
      case SkillRang.F:
        return Colors.grey;
      case SkillRang.E:
        return Colors.blueGrey;
      case SkillRang.D:
        return Colors.blue;
      case SkillRang.C:
        return Colors.green;
      case SkillRang.B:
        return Colors.lime;
      case SkillRang.A:
        return Colors.orange;
      case SkillRang.S:
        return Colors.red;
      case SkillRang.SS:
        return Colors.purple;
      case SkillRang.SSS:
        return Colors.deepPurple;
      case SkillRang.EX:
        return Colors.amber;
    }
  }

  Future<void> _pickIcon(SkillFormModel viewModel) async {
    final success = await viewModel.pickIcon();
    if (success && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Иконка выбрана')),
      );
    }
  }

  Future<void> _saveSkill(BuildContext context) async {
    final success = await _viewModel.saveSkill();
    if (!context.mounted) return;
    
    if (success) {
      Navigator.pop(context, true);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(_viewModel.error ?? 'Ошибка сохранения'),
          backgroundColor: Colors.red,
        ),
      );
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