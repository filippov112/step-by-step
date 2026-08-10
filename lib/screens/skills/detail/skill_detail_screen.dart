// lib/screens/skills/skill_detail_screen.dart
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:life_game/models/skill_condition.dart';
import 'package:life_game/screens/skills/detail/skill_detail_model.dart';
import 'package:life_game/screens/skills/form/skill_form_screen.dart';
import 'package:life_game/services/exp_calculator.dart';
import 'package:life_game/themes/solo_leveling_theme.dart';
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

            var descriptionsCard = _buildDescriptionsCard(viewModel);
            
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
                            
                          ],
                        ),
                      ),
                      Container(
                        width: 64,
                        height: 64,
                        decoration: BoxDecoration(
                          color: skill.rang.color.withAlpha(40),
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [BoxShadow(color: skill.rang.color.withAlpha(100), blurRadius: 10)],
                        ),
                        child: Center(child:Text(skill.rang.name, style: TextStyle(fontSize: 32, color: skill.rang.color),),),
                      )
                    ],
                  ),
                  const SizedBox(height: 12),
                  
                  // Прогресс
                  _buildProgressCard(viewModel),
                  const SizedBox(height: 12),
                  
                  // Кнопка повышения ранга
                  if (viewModel.canUpgradeRank()) ...{
                    _buildUpgradeButton(viewModel),
                    const SizedBox(height: 12),
                  },
                    
                  // Описания для рангов
                  if (descriptionsCard != null) ...{
                    descriptionsCard,
                    const SizedBox(height: 12),
                  },

                  // Условия
                  if (viewModel.conditions.isNotEmpty) ...{
                    _buildConditionsCard(viewModel)
                  },
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
          color: SoloLevelingTheme.steelBlue,
          borderRadius: BorderRadius.circular(12),
        ),
        child: const Icon(Icons.star_border, size: 32, color: SoloLevelingTheme.paleBlue),
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
                color: SoloLevelingTheme.steelBlue,
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(Icons.broken_image, color: SoloLevelingTheme.paleBlue),
            );
          },
        ),
      );
    } catch (e) {
      return Container(
        width: 64,
        height: 64,
        decoration: BoxDecoration(
          color: SoloLevelingTheme.steelBlue,
          borderRadius: BorderRadius.circular(12),
        ),
        child: const Icon(Icons.image_not_supported, color: SoloLevelingTheme.paleBlue),
      );
    }
  }

  Widget _buildProgressCard(SkillDetailModel viewModel) {
    final int exp = viewModel.skill?.experience ?? 0;
    final int level = viewModel.skill?.level ?? 1;
    final int nextLevelExp = ExpCalculator.calcNextLevelExp(level);

    final progress = (exp / nextLevelExp).clamp(0.0, 1.0);
    
    return Card(
      margin: EdgeInsetsGeometry.all(0),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Накоплено:'),
                Text('${NumberFormat('#,##0', 'en_US').format(exp)} EXP', 
                  style: const TextStyle(fontWeight: FontWeight.bold)),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Осталось:'),
                Text('${NumberFormat('#,##0', 'en_US').format(nextLevelExp - exp)} EXP', 
                  style: const TextStyle(fontWeight: FontWeight.bold)),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${NumberFormat('#,##0', 'en_US').format(level)} LVL',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                Text('${NumberFormat("#0.00").format(progress * 100)}%'),
              ],
            ),
            const SizedBox(height: 8),
            LinearProgressIndicator(
              // value: progress,
              value: 0.3,
              backgroundColor: Colors.grey.shade200,
              minHeight: 8,
              borderRadius: BorderRadius.all(Radius.circular(4)),
            ),
          ],
        ),
      ),
    );
  }

  Widget? _buildDescriptionsCard(SkillDetailModel viewModel) {
    var descs = SkillRang.values.where((rang) => _checkDescriptionTile(viewModel, rang)).map((rang) => _buildDescriptionTile(viewModel, rang));
    List<Widget> descList = [];
    for(var desc in descs) {
      descList.add(desc);
      descList.add(Divider());
    }
    if (descs.isEmpty) {
      return null;
    } 
    descList.removeLast();   

    return Card(
      margin: EdgeInsetsGeometry.all(0),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ...descList,
          ],
        ),
      ),
    );
  }

  Widget _buildConditionsCard(SkillDetailModel viewModel) {
    var conditions = viewModel.conditions.map((condition) {
                      return _buildConditionTile(viewModel, condition);
                    });

    return Card(
      margin: EdgeInsetsGeometry.all(0),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ...conditions
          ],
        ),
      ),
    );
  }


  Widget _buildUpgradeButton(SkillDetailModel viewModel) {
    final nextRang = viewModel.getNextRangForUpgrade();
    
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 6),
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
      child: ListTile(
        titleTextStyle: TextStyle(fontWeight: FontWeight.normal),
        titleAlignment: ListTileTitleAlignment.top,
        leading: Column(mainAxisSize: MainAxisSize.max, mainAxisAlignment: MainAxisAlignment.start, children: [
          Text(rang.name, style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: rang.color)),
        ]),
        title: Text(description, style: TextStyle(color: SoloLevelingTheme.paleBlue)),
      ),
    );
  }

  Widget _buildConditionTile(SkillDetailModel viewModel, SkillCondition condition) {
    final isCompleted = viewModel.completedConditions[condition.id] ?? false;
    
    return Card(
      child: ListTile(
        contentPadding: EdgeInsetsGeometry.all(10),
        leading: Container(
          width: 40,
          height: 40,
          margin: EdgeInsetsGeometry.fromLTRB(8,0,0,0),
          decoration: BoxDecoration(
            color: condition.rang.color.withValues(alpha: 0.2),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Center(
            child: Text(
              condition.rang.name,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: condition.rang.color,
              ),
            ),
          ),
        ),
        title: Text(
          condition.description.isNotEmpty ? condition.description : 'Без описания',
          style: TextStyle(
            decoration: isCompleted ? TextDecoration.lineThrough : null,
            color: isCompleted ? SoloLevelingTheme.steelBlue : SoloLevelingTheme.paleBlue,
          ),
        ),
        subtitle: condition.date != null
            ? Text('Выполнено: ${condition.date!.day}.${condition.date!.month}.${condition.date!.year}',
              style: TextStyle(color: SoloLevelingTheme.steelBlue)
            )
            : null,
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Checkbox(
              value: isCompleted,
              onChanged: (_) => viewModel.toggleConditionCompletion(condition.id),
            ),
          ],
        ),
        onTap: () => viewModel.toggleConditionCompletion(condition.id),
      ),
    );
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
              style: TextStyle(color: SoloLevelingTheme.steelBlue, fontSize: 14),
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