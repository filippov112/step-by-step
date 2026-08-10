// lib/widgets/achievement_form.dart
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:life_game/models/achievement.dart';
import 'package:life_game/models/enums/achiev_rar.dart';
import 'package:life_game/models/tag.dart';
import 'package:life_game/screens/achievements/achievement_list_model.dart';
import 'package:life_game/screens/achievements/widgets/tag_selector_modal.dart';
import 'package:life_game/widgets/tag_chip.dart';
import 'package:provider/provider.dart';

class AchievementForm extends StatefulWidget {
  final Achievement? achievement;

  const AchievementForm({Key? key, this.achievement}) : super(key: key);

  @override
  State<AchievementForm> createState() => _AchievementFormState();
}

class _AchievementFormState extends State<AchievementForm> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  
  AchievRar _selectedRarity = AchievRar.common;
  List<Tag> _selectedTags = [];
  String? _iconPath;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    if (widget.achievement != null) {
      _titleController.text = widget.achievement!.title;
      _descriptionController.text = widget.achievement!.description;
      _selectedRarity = widget.achievement!.rarity;
      _iconPath = widget.achievement!.icon;
      _loadTags();
    }
  }

  Future<void> _loadTags() async {
    if (widget.achievement != null) {
      final viewModel = context.read<AchievementListModel>();
      final tags = await viewModel.getTagsForAchievement(widget.achievement!.id);
      setState(() {
        _selectedTags = tags;
      });
    }
  }

  Future<void> _pickIcon() async {
    final viewModel = context.read<AchievementListModel>();
    final file = await viewModel.pickIcon();
    if (file != null) {
      final path = await viewModel.saveIcon(file);
      setState(() {
        _iconPath = path;
      });
    }
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final viewModel = context.read<AchievementListModel>();
      
      if (widget.achievement == null) {
        await viewModel.createAchievement(
          title: _titleController.text,
          description: _descriptionController.text,
          rarity: _selectedRarity,
          icon: _iconPath,
          tags: _selectedTags,
        );
      } else {
        await viewModel.updateAchievement(
          widget.achievement!,
          title: _titleController.text,
          description: _descriptionController.text,
          rarity: _selectedRarity,
          icon: _iconPath,
          tags: _selectedTags,
        );
      }

      if (mounted) {
        Navigator.of(context).pop(true);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Ошибка: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  void _showTagSelector() async {
    await showDialog<List<Tag>>(
      context: context,
      builder: (context) => Dialog(
        child: TagSelectorModal(
          selectedTags: _selectedTags,
          onConfirm: (tags) {
            setState(() {
              _selectedTags = tags;
            });
          },
        ),
      ) 
    );
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.9,
        ),
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.achievement == null ? 'Создание достижения' : 'Редактирование достижения',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: 20),
              // Иконка
              GestureDetector(
                onTap: _pickIcon,
                child: Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    color: Theme.of(context).cardColor,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Theme.of(context).dividerColor),
                  ),
                  child: _iconPath != null
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image.file(
                            File(_iconPath!),
                            fit: BoxFit.cover,
                          ),
                        )
                      : Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.add_photo_alternate,
                              color: Theme.of(context).hintColor,
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Иконка',
                              style: TextStyle(
                                fontSize: 10,
                                color: Theme.of(context).hintColor,
                              ),
                            ),
                          ],
                        ),
                ),
              ),
              const SizedBox(height: 16),
              // Название
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(
                  labelText: 'Название',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value?.isEmpty ?? true) {
                    return 'Введите название';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              // Описание
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(
                  labelText: 'Описание',
                  border: OutlineInputBorder(),
                ),
                maxLines: 3,
              ),
              const SizedBox(height: 16),
              // Редкость
              DropdownButtonFormField<AchievRar>(
                initialValue: _selectedRarity,
                decoration: const InputDecoration(
                  labelText: 'Редкость',
                  border: OutlineInputBorder(),
                ),
                items: AchievRar.values.map((rarity) {
                  return DropdownMenuItem(
                    value: rarity,
                    child: Row(
                      children: [
                        Container(
                          width: 16,
                          height: 16,
                          decoration: BoxDecoration(
                            color: rarity.color,
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(rarity.displayName),
                      ],
                    ),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedRarity = value!;
                  });
                },
              ),
              const SizedBox(height: 16),
              // Теги
              Row(
                children: [
                  Expanded(
                    child: Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [ ..._selectedTags.map((t) => TagChip(title: t.title))],
                    ),
                  ),
                  TextButton(
                    onPressed: _showTagSelector,
                    child: Text('Выбрать теги'),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              // Кнопки
              Row(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Expanded(
                    flex: 1, 
                    child: OutlinedButton(
                      onPressed: _isLoading ? null : () => Navigator.of(context).pop(),
                      child: const Text('Отмена'),
                    ),
                  ),
                  
                  const SizedBox(width: 8),
                  Expanded(
                    flex: 1, 
                    child: ElevatedButton(
                      onPressed: _isLoading ? null : _submit,
                      child: _isLoading
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : const Text('Сохранить'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}