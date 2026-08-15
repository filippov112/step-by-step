// lib/screens/skills/widgets/conditions_list_widget.dart
import 'package:flutter/material.dart';
import 'package:life_game/models/skill_condition.dart';
import 'package:life_game/models/enums/skill_rang.dart';
import 'package:life_game/screens/skills/form/widgets/skill_condition_dialog.dart';
import 'package:life_game/themes/solo_leveling_theme.dart';
import 'package:life_game/widgets/common/confirm_dialog.dart';
import 'package:life_game/widgets/common/custom_text.dart';

class ConditionsListWidget extends StatelessWidget {
  final List<SkillCondition> conditions;
  final Function(SkillCondition) onAdd;
  final Function(int, SkillCondition) onEdit;
  final Function(int) onDelete;
  
  const ConditionsListWidget({
    super.key,
    required this.conditions,
    required this.onAdd,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const CustomText(
              'Условия прокачки',
              expanded: true,
              size: 18, weight: FontWeight.bold
            ),
            IconButton(
              onPressed: () => _showAddConditionDialog(context),
              icon: const Icon(Icons.add, size: 18),
            ),
          ],
        ),
        const SizedBox(height: 8),
        if (conditions.isEmpty)
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              // color: Colors.grey.shade50,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: SoloLevelingTheme.steelBlue),
            ),
            child: const Center(
              child: CustomText(
                'Нет добавленных условий',
                color: SoloLevelingTheme.steelBlue,
              ),
            ),
          )
        else
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: conditions.length,
            itemBuilder: (context, index) {
              final condition = conditions[index];
              return _buildConditionTile(context, condition, index);
            },
          ),
      ],
    );
  }

  Widget _buildConditionTile(BuildContext context, SkillCondition condition, int index) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 4),
      child: ListTile(
        minTileHeight: 72,
        leading: Container(
          width: 40,
          height: 40,
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
        title: Text(condition.description.isNotEmpty ? condition.description : 'Без описания',
          style: TextStyle(color: SoloLevelingTheme.paleBlue)),
        subtitle: condition.date != null
            ? Text('Выполнено: ${condition.date!.day}.${condition.date!.month}.${condition.date!.year}', 
              style: TextStyle(color: SoloLevelingTheme.glowBlue))
            : null,
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(Icons.edit, color: SoloLevelingTheme.steelBlue, size: 20),
              onPressed: () => _showEditConditionDialog(context, index, condition),
              tooltip: 'Редактировать',
            ),
            IconButton(
              icon: const Icon(Icons.delete, color: SoloLevelingTheme.steelBlue, size: 20),
              onPressed: () => _confirmDelete(context, index),
              tooltip: 'Удалить',
            ),
          ],
        ),
      ),
    );
  }

  void _showAddConditionDialog(BuildContext context) async {
    final result = await showDialog<Map<String, dynamic>>(
      context: context,
      builder: (context) => const ConditionDialog(),
    );
    
    if (result != null && result['condition'] != null) {
      onAdd(result['condition']);
    }
  }

  void _showEditConditionDialog(BuildContext context, int index, SkillCondition condition) async {
    final result = await showDialog<Map<String, dynamic>>(
      context: context,
      builder: (context) => ConditionDialog(
        existingCondition: condition,
        editIndex: index,
      ),
    );
    
    if (result != null && result['condition'] != null) {
      final editIndex = result['editIndex'] as int;
      onEdit(editIndex, result['condition']);
    }
  }

  Future _confirmDelete(BuildContext context, int index) async {
    if (await showConfirmDialog(context) == true) {
      onDelete(index);
    }
  }
}