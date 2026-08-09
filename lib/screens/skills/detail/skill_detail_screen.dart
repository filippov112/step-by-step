// lib/screens/skills/skill_detail_screen.dart
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:life_game/models/skill_condition.dart';
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
                  
                  // Кнопка повышения ранга
                  if (viewModel.canUpgradeRank())
                    _buildUpgradeButton(viewModel),
                  
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
                      return _buildConditionTile(viewModel, condition);
                    }),
                  ],
                  
                  const SizedBox(height: 24),
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
              color: progress >= 1.0 ? Colors.green : Colors.blue,
              minHeight: 8,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildUpgradeButton(SkillDetailModel viewModel) {
    final nextRang = viewModel.getNextRangForUpgrade();
    
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: ElevatedButton.icon(
        onPressed: () => _confirmUpgrade(context, viewModel),
        icon: const Icon(Icons.arrow_upward),
        label: Text(
          'Повысить ранг до ${nextRang?.name ?? ''}',
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.amber,
          foregroundColor: Colors.black,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
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

  Widget _buildConditionTile(SkillDetailModel viewModel, SkillCondition condition) {
    final isCompleted = viewModel.completedConditions[condition.id] ?? false;
    
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 4),
      child: ListTile(
        leading: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: _getRangColor(condition.rang).withOpacity(0.2),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Center(
            child: Text(
              condition.rang.name,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: _getRangColor(condition.rang),
              ),
            ),
          ),
        ),
        title: Text(
          condition.description.isNotEmpty ? condition.description : 'Без описания',
          style: TextStyle(
            decoration: isCompleted ? TextDecoration.lineThrough : null,
            color: isCompleted ? Colors.grey : Colors.black,
          ),
        ),
        subtitle: condition.date != null
            ? Text('Выполнено: ${condition.date!.day}.${condition.date!.month}.${condition.date!.year}')
            : null,
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (isCompleted)
              const Padding(
                padding: EdgeInsets.only(right: 8),
                child: Icon(Icons.check_circle, color: Colors.green),
              ),
            Checkbox(
              value: isCompleted,
              onChanged: (_) => viewModel.toggleConditionCompletion(condition.id),
              activeColor: Colors.green,
            ),
          ],
        ),
        onTap: () => viewModel.toggleConditionCompletion(condition.id),
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

  bool _checkDescriptionTile(SkillDetailModel viewModel, SkillRang rang) {
    final description = viewModel.getDescriptionForRang(rang);
    return description != null && description.isNotEmpty;
  }

  void _confirmUpgrade(BuildContext context, SkillDetailModel viewModel) {
    final nextRang = viewModel.getNextRangForUpgrade();
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Повышение ранга'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Вы хотите повысить ранг навыка до "${nextRang?.name}"?',
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 8),
            const Text(
              'Это действие нельзя отменить.',
              style: TextStyle(color: Colors.grey, fontSize: 14),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Отмена'),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(context);
              final success = await viewModel.upgradeRank();
              if (success && mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Ранг успешно повышен!'),
                    backgroundColor: Colors.green,
                  ),
                );
              } else if (!success && mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(viewModel.error ?? 'Ошибка повышения ранга'),
                    backgroundColor: Colors.red,
                  ),
                );
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.amber,
              foregroundColor: Colors.black,
            ),
            child: const Text('Повысить'),
          ),
        ],
      ),
    );
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
}