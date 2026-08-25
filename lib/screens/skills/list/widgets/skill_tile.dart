import 'package:flutter/material.dart';
import 'package:chaos_control/models/enums/skill_rang.dart';
import 'package:chaos_control/models/skill.dart';
import 'package:chaos_control/screens/skills/detail/skill_detail_model.dart';
import 'package:chaos_control/screens/skills/detail/skill_detail_screen.dart';
import 'package:chaos_control/screens/skills/list/skill_list_model.dart';
import 'package:chaos_control/services/exp_calculator.dart';
import 'package:chaos_control/widgets/dialogs/confirm_dialog.dart';
import 'package:chaos_control/widgets/common/custom_image_icon.dart';
import 'package:chaos_control/widgets/common/custom_text.dart';
import 'package:provider/provider.dart';


class SkillTile extends StatelessWidget {

  final SkillListModel model;
  final Skill skill;

  const SkillTile({
    super.key, 
    required this.model, 
    required this.skill,
  });

  @override
  Widget build(BuildContext context) {

    final isSelected = model.selectedIds.contains(skill.id);

    Color? containterColor = Theme.of(context).colorScheme.surfaceContainerHighest.withValues(alpha: 0.9);
    Gradient containterBorderColor = LinearGradient(
      transform: GradientRotation(0.7),
      colors: [skill.rang.color.withValues(alpha: 0.5), containterColor],
      stops: [0, 0.2]);
    
    Color titleColor = Theme.of(context).colorScheme.onPrimary;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Container(
        decoration: BoxDecoration(
          gradient: containterBorderColor,
          borderRadius: BorderRadius.all(Radius.circular(16)),
          color: containterColor,
        ),
        child: InkWell(
          borderRadius: BorderRadius.all(Radius.circular(16)),
          onTap: () {
            if (model.isSelectionMode) {
              model.toggleSelectSkill(skill.id);
            } else {
              _openDetails(context, model, skill);
            }
          },
          onLongPress: () {
            if (!model.isSelectionMode) {
              model.toggleSelectionMode();
              model.toggleSelectSkill(skill.id);
            }
          },
          child: Padding(
            padding: const EdgeInsets.all(0),
            child: Row(
              children: [
                // Чекбокс для выделения или статуса
                Padding(
                  padding: EdgeInsetsGeometry.only(right: 12),
                  child: model.isSelectionMode ? Checkbox(
                      value: isSelected,
                      onChanged: (_) => model.toggleSelectSkill(skill.id),
                    ) :
                    Padding(
                      padding: const EdgeInsetsGeometry.fromLTRB(12,12,0,12), 
                      child: CustomImageIcon(
                        skill.icon, 
                        altIcon: Icons.star_border, 
                        color: skill.rang.color, 
                        width: 40, height: 40
                      ),
                    ),
                ),
                
                // Информация
                Expanded(
                  child: Text(
                    skill.title,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      color: titleColor,
                    ),
                  ),
                ),
                  
                Container(
                  margin: const EdgeInsets.fromLTRB(0,12,12,12),
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: skill.rang.color.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: CustomText(
                    '${ExpCalculator.getLevel(skill.experience)}',
                    size: 18,
                    color: skill.rang.color,
                    weight: FontWeight.w600,
                  ),
                ),
                
                if (model.isSelectionMode) ...{
                  SizedBox(width: 8,),
                  IconButton(
                    icon: const Icon(Icons.delete_outline, size: 16),
                    onPressed: () => _deleteSkill(context, skill, model.deleteSkill),
                    tooltip: 'Удалить',
                  ),
                }
              ],
            ),
          ),
        ),
      )
    );
  }

  Future<void> _deleteSkill(BuildContext context, Skill skill, Future Function(String) deleteSkill) async {
    if (await showConfirmDialog(context) == true) {
      await deleteSkill(skill.id);
    }
  }


  Future _openDetails(BuildContext context, SkillListModel model, Skill skill) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ChangeNotifierProvider(
          create: (context) => SkillDetailModel(), 
          child: SkillDetailScreen(skillId: skill.id),
        ),
      ),
    );
    if (context.mounted) model.loadSkills(); 
  }
}