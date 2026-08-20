import 'package:flutter/material.dart';
import 'package:life_game/models/class_skill.dart';
import 'package:life_game/models/skill_condition.dart';
import 'package:life_game/models/enums/skill_rang.dart';
import 'package:life_game/screens/skills/form/widgets/skill_condition_dialog.dart';
import 'package:life_game/widgets/common/confirm_dialog.dart';
import 'package:life_game/widgets/common/custom_text.dart';

class SkillsBlock extends StatelessWidget {
  final List<ClassSkill> classSkills;
  final Function(ClassSkill) onAdd;
  final Function(int, ClassSkill) onEdit;
  final Function(int) onDelete;
  
  const SkillsBlock({
    super.key,
    required this.classSkills,
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
              'Навыки',
              expanded: true,
              size: 18, weight: FontWeight.bold
            ),
            IconButton(
              onPressed: () => _showAddConditionDialog(context),
              icon: const Icon(Icons.add),
            ),
          ],
        ),
        const SizedBox(height: 8),
        if (classSkills.isEmpty)
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Theme.of(context).dividerColor),
            ),
            child: Center(
              child: CustomText(
                'Нет связанных навыков',
                color: Theme.of(context).dividerColor,
              ),
            ),
          )
        else
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: classSkills.length,
            itemBuilder: (context, index) {
              final classSkill = classSkills[index];
              return _buildSkillTile(context, classSkill, index);
            },
          ),
      ],
    );
  }

  Widget _buildSkillTile(BuildContext context, ClassSkill classSkill, int index) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 4),
      child: ListTile(
        minTileHeight: 72,
        leading: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: classSkill.rang.color.withValues(alpha: 0.2),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Center(
            child: Text(
              classSkill.rang.name,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: classSkill.rang.color,
              ),
            ),
          ),
        ),
        title: Text(classSkill.description.isNotEmpty ? classSkill.description : 'Без описания',
          style:Theme.of(context).textTheme.bodyMedium
        ),
        subtitle: classSkill.date != null
            ? Text('Выполнено: ${classSkill.date!.day}.${classSkill.date!.month}.${classSkill.date!.year}')
            : null,
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: Icon(Icons.edit, color: Theme.of(context).dividerColor, size: 20),
              onPressed: () => _showEditConditionDialog(context, index, classSkill),
              tooltip: 'Редактировать',
            ),
            IconButton(
              icon: Icon(Icons.delete, color: Theme.of(context).dividerColor, size: 20),
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