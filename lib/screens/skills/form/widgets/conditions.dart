import 'package:flutter/material.dart';
import 'package:life_game/models/skill_condition.dart';
import 'package:life_game/screens/skills/form/skill_form_model.dart';
import 'package:life_game/screens/skills/form/widgets/condition_tile.dart';
import 'package:life_game/screens/skills/form/widgets/condition_single_dialog.dart';
import 'package:life_game/widgets/dialogs/confirm_dialog.dart';
import 'package:life_game/widgets/common/custom_text.dart';
import 'package:provider/provider.dart';

class SkillFormConditions extends StatefulWidget {
  const SkillFormConditions({super.key});

  @override
  State<SkillFormConditions> createState() => _SkillFormConditionsState();
}

class _SkillFormConditionsState extends State<SkillFormConditions> {
  @override
  Widget build(BuildContext context) {
    final model = context.read<SkillFormModel>();
    final addCondition = model.addCondition;
    final updateCondition = model.updateCondition;
    final removeCondition = model.removeCondition;

    final conditions = context.select<SkillFormModel, List<SkillCondition>>(
      (m) => m.selectedConditions,
    );

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
        if (conditions.isEmpty)
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
            itemCount: conditions.length,
            itemBuilder: (context, index) {
              final condition = conditions[index];
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

  Future _showAddConditionDialog(
    BuildContext context,
    Function(SkillCondition) setCondition,
  ) async {
    await showDialog<Map<String, dynamic>>(
      context: context,
      builder: (context) =>
          SkillFormConditionDialog(saveCallback: (v) => setCondition(v)),
    );
  }

  Future _showEditConditionDialog(
    BuildContext context,
    int index,
    SkillCondition condition,
    Function(int, SkillCondition) updateCondition,
  ) async {
    await showDialog<Map<String, dynamic>>(
      context: context,
      builder: (context) => SkillFormConditionDialog(
        existingCondition: condition,
        saveCallback: (v) => updateCondition(index, v),
      ),
    );
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
