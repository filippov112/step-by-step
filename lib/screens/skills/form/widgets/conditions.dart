import 'package:flutter/material.dart';
import 'package:life_game/models/skill_condition.dart';
import 'package:life_game/screens/skills/form/skill_form_model.dart';
import 'package:life_game/screens/skills/form/widgets/condition_tile.dart';
import 'package:life_game/screens/skills/form/widgets/condition_single_dialog.dart';
import 'package:life_game/widgets/dialogs/confirm_dialog.dart';
import 'package:life_game/widgets/common/custom_text.dart';
import 'package:provider/provider.dart';

class SkillFormConditions extends StatelessWidget {
  const SkillFormConditions({super.key});

  @override
  Widget build(BuildContext context) {
    final model = context.read<SkillFormModel>();
    final selectedConditions = context
        .select<SkillFormModel, List<SkillCondition>>(
          (model) => model.selectedConditions,
        );
    final addCondition = model.addCondition;
    final updateCondition = model.updateCondition;
    final removeCondition = model.removeCondition;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const CustomText(
              'Условия прокачки',
              expanded: true,
              size: 18,
              weight: FontWeight.bold,
            ),
            IconButton(
              onPressed: () => _showAddConditionDialog(context, addCondition),
              icon: const Icon(Icons.add, size: 18),
            ),
          ],
        ),
        const SizedBox(height: 8),
        if (selectedConditions.isEmpty)
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Theme.of(context).dividerColor),
            ),
            child: Center(
              child: CustomText(
                'Нет добавленных условий',
                color: Theme.of(context).dividerColor,
              ),
            ),
          )
        else
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: selectedConditions.length,
            itemBuilder: (context, index) {
              final condition = selectedConditions[index];
              return SkillFormConditionTile(
                condition: condition,
                editCallback: () => _showEditConditionDialog(
                  context,
                  index,
                  condition,
                  updateCondition,
                ),
                deleteCallback: () =>
                    _confirmDelete(context, index, removeCondition),
              );
            },
          ),
      ],
    );
  }

  void _showAddConditionDialog(
    BuildContext context,
    Function(SkillCondition) setCondition,
  ) async {
    final result = await showDialog<Map<String, dynamic>>(
      context: context,
      builder: (context) => const SkillFormConditionDialog(),
    );

    if (result != null && result['condition'] != null) {
      setCondition(result['condition']);
    }
  }

  void _showEditConditionDialog(
    BuildContext context,
    int index,
    SkillCondition condition,
    Function(int, SkillCondition) updateCondition,
  ) async {
    final result = await showDialog<Map<String, dynamic>>(
      context: context,
      builder: (context) => SkillFormConditionDialog(
        existingCondition: condition,
        editIndex: index,
      ),
    );

    if (result != null && result['condition'] != null) {
      final editIndex = result['editIndex'] as int;
      updateCondition(editIndex, result['condition']);
    }
  }

  Future _confirmDelete(
    BuildContext context,
    int index,
    Function(int) removeCondition,
  ) async {
    if (await showConfirmDialog(context) == true) {
      removeCondition(index);
    }
  }
}
