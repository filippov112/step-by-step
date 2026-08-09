import 'dart:io';

import 'package:flutter/material.dart';
import 'package:life_game/screens/skills/detail/skill_detail_model.dart';
import 'package:life_game/screens/skills/form/skill_form_screen.dart';
import 'package:provider/provider.dart';
import 'package:life_game/models/enums/skill_rang.dart';

class SkillDetailScreen extends StatefulWidget {

  final String skillId;
  
  const SkillDetailScreen({super.key, required this.skillId});

  @override
  State<SkillDetailScreen> createState() => _SkillDetailScreenState();
}

class _SkillDetailScreenState extends State<SkillDetailScreen> {
  late SkillDetailModel _viewModel;

  @override
  void initState() {
    super.initState();
    _viewModel = SkillDetailModel();
    _viewModel.loadSkill(widget.skillId);
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
          title: const Text('Детали навыка'),
          actions: [
            Consumer<SkillDetailModel>(
              builder: (context, viewModel, child) {
                if (viewModel.skill == null) return const SizedBox();
                return IconButton(
                  icon: const Icon(Icons.edit),
                  onPressed: () => _navigateToEdit(context),
                  tooltip: 'Редактировать',
                );
              },
            ),
          ],
        ),
        body: Consumer<SkillDetailModel>(
          builder: (context, viewModel, child) {
            if (viewModel.isLoading) {
              return const Center(child: CircularProgressIndicator());
            }
            
            if (viewModel.error != null) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.error_outline, size: 64, color: Colors.red.shade300),
                    const SizedBox(height: 16),
                    Text(
                      viewModel.error!,
                      textAlign: TextAlign.center,
                      style: const TextStyle(color: Colors.red),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () => viewModel.loadSkill(widget.skillId),
                      child: const Text('Попробовать снова'),
                    ),
                  ],
                ),
              );
            }
            
            if (viewModel.skill == null) {
              return const Center(child: Text('Навык не найден'));
            }
            
            final skill = viewModel.skill!;
            
            return SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Заголовок с иконкой
                  Row(
                    children: [
                      _buildSkillIcon(skill.icon),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              skill.title,
                              style: const TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Ранг: ${skill.rang.name}',
                              style: TextStyle(
                                fontSize: 16,
                                color: _getRangColor(skill.rang),
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  
                  // Статистика
                  _buildStatCard(viewModel),
                  const SizedBox(height: 24),
                  
                  // Прогресс
                  _buildProgressCard(viewModel),
                  const SizedBox(height: 24),
                  
                  // Описания для рангов
                  const Text(
                    'Описания',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  ...SkillRang.values.where((rang) => _checkDescriptionTile(viewModel, rang)).map((rang) => _buildDescriptionTile(viewModel, rang)),
                  
                  // Условия
                  if (viewModel.conditions.isNotEmpty) ...[
                    const SizedBox(height: 24),
                    const Text(
                      'Условия прокачки',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    ...viewModel.conditions.map((condition) {
                      return Card(
                        margin: const EdgeInsets.symmetric(vertical: 4),
                        child: ListTile(
                          leading: Icon(
                            _getConditionIcon(condition.rang),
                            color: _getRangColor(condition.rang),
                          ),
                          title: Text('Ранг ${condition.rang.name}'),
                          subtitle: condition.description.isNotEmpty
                              ? Text(condition.description)
                              : null,
                          trailing: Text(
                            condition.date != null
                                ? '${condition.date!.day}.${condition.date!.month}.${condition.date!.year}'
                                : '',
                          ),
                        ),
                      );
                    }),
                  ],
                  
                  // Кнопки действий
                  const SizedBox(height: 24),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: () => _navigateToEdit(context),
                          icon: const Icon(Icons.edit),
                          label: const Text('Редактировать'),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () => _showAddConditionDialog(context),
                          icon: const Icon(Icons.add),
                          label: const Text('Добавить условие'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green,
                          ),
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

  Widget _buildSkillIcon(String iconPath) {
    if (iconPath.isEmpty) {
      return Container(
        width: 64,
        height: 64,
        decoration: BoxDecoration(
          color: Colors.grey.shade200,
          borderRadius: BorderRadius.circular(12),
        ),
        child: const Icon(Icons.star_border, size: 32, color: Colors.grey),
      );
    }
    
    try {
      return ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Image.file(
          File(iconPath),
          width: 64,
          height: 64,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            return Container(
              width: 64,
              height: 64,
              decoration: BoxDecoration(
                color: Colors.grey.shade200,
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(Icons.broken_image, color: Colors.grey),
            );
          },
        ),
      );
    } catch (e) {
      return Container(
        width: 64,
        height: 64,
        decoration: BoxDecoration(
          color: Colors.grey.shade200,
          borderRadius: BorderRadius.circular(12),
        ),
        child: const Icon(Icons.image_not_supported, color: Colors.grey),
      );
    }
  }

  Widget _buildStatCard(SkillDetailModel viewModel) {
    final skill = viewModel.skill!;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _statItem('Уровень', skill.level.toString(), Icons.numbers),
            _statItem('Опыт', skill.experience.toString(), Icons.star),
            _statItem('Ранг', skill.rang.name, Icons.arrow_upward),
          ],
        ),
      ),
    );
  }

  Widget _statItem(String label, String value, IconData icon) {
    return Column(
      children: [
        Icon(icon, size: 24, color: Colors.grey.shade600),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        Text(
          label,
          style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
        ),
      ],
    );
  }

  Widget _buildProgressCard(SkillDetailModel viewModel) {
    final nextRang = viewModel.getNextRang();
    final progress = viewModel.getProgressToNextRang();
    
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Прогресс до ранга ${nextRang?.name ?? 'MAX'}',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                Text('${(progress * 100).toInt()}%'),
              ],
            ),
            const SizedBox(height: 8),
            LinearProgressIndicator(
              value: progress,
              backgroundColor: Colors.grey.shade200,
              color: Colors.green,
              minHeight: 8,
            ),
          ],
        ),
      ),
    );
  }

  bool _checkDescriptionTile(SkillDetailModel viewModel, SkillRang rang) {
    final description = viewModel.getDescriptionForRang(rang);

    return description != null && description.isNotEmpty;
  }

  Widget _buildDescriptionTile(SkillDetailModel viewModel, SkillRang rang) {
    final description = viewModel.getDescriptionForRang(rang) ?? '';

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Card(
        child: ListTile(
          leading: Icon(
            Icons.description,
            color: _getRangColor(rang),
          ),
          title: Text('Ранг ${rang.name}'),
          subtitle: Text(description),
        ),
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

  IconData _getConditionIcon(SkillRang rang) {
    switch (rang) {
      case SkillRang.F:
        return Icons.fiber_manual_record;
      case SkillRang.E:
        return Icons.fiber_manual_record;
      case SkillRang.D:
        return Icons.fiber_manual_record;
      case SkillRang.C:
        return Icons.fiber_manual_record;
      case SkillRang.B:
        return Icons.fiber_manual_record;
      case SkillRang.A:
        return Icons.fiber_manual_record;
      case SkillRang.S:
        return Icons.fiber_manual_record;
      case SkillRang.SS:
        return Icons.fiber_manual_record;
      case SkillRang.SSS:
        return Icons.fiber_manual_record;
      case SkillRang.EX:
        return Icons.fiber_manual_record;
    }
  }

  void _navigateToEdit(BuildContext context) {
    if (_viewModel.skill == null) return;
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SkillFormScreen(skill: _viewModel.skill),
      ),
    ).then((result) {
      if (result == true) {
        _viewModel.loadSkill(widget.skillId);
      }
    });
  }

  void _showAddConditionDialog(BuildContext context) {
    // Здесь можно реализовать диалог добавления условия
    // Пока просто показываем заглушку
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Добавление условия'),
        content: const Text('Функция добавления условий будет реализована позже'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Закрыть'),
          ),
        ],
      ),
    );
  }
}