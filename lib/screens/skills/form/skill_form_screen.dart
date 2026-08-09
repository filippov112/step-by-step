import 'package:flutter/material.dart';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:life_game/models/skill.dart';
import 'package:life_game/screens/skills/form/skill_form_model.dart';
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

  // final TextEditingController _title_Controller = TextEditingController();
  // final TextEditingController _level_Controller = TextEditingController();
  // final TextEditingController _exp_Controller = TextEditingController();

  // final TextEditingController _rang_ex_Controller = TextEditingController();
  // final TextEditingController _rang_sss_Controller = TextEditingController();
  // final TextEditingController _rang_ss_Controller = TextEditingController();
  // final TextEditingController _rang_s_Controller = TextEditingController();
  // final TextEditingController _rang_a_Controller = TextEditingController();
  // final TextEditingController _rang_b_Controller = TextEditingController();
  // final TextEditingController _rang_c_Controller = TextEditingController();
  // final TextEditingController _rang_d_Controller = TextEditingController();
  // final TextEditingController _rang_e_Controller = TextEditingController();
  // final TextEditingController _rang_f_Controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    _viewModel = SkillFormModel();
    if (widget.skill != null) {
      _viewModel.loadSkillForEditing(widget.skill!);
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
                    value: viewModel.rang,
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
                  
                  // Уровень
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
                  
                  // Описания для каждого ранга
                  const Text(
                    'Описания для рангов',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  ...SkillRang.values.map((rang) {
                    return _buildDescriptionField(viewModel, rang);
                  }),
                  
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
                          onPressed: () => Navigator.pop(context, false),
                          child: const Text('Отмена'),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () => _saveSkill(context),
                          child: Text(widget.skill == null ? 'Создать' : 'Сохранить'),
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
                child: Image.file(
                  File(viewModel.iconPath),
                  width: double.infinity,
                  height: 120,
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
        ),
        maxLines: 2,
        initialValue: description ?? '',
        onChanged: (value) => viewModel.setDescription(rang, value),
      ),
    );
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
    if (!mounted) return;
    
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
              Navigator.pop(context, true); // Возвращаем true для обновления списка
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Удалить'),
          ),
        ],
      ),
    );
  }
}