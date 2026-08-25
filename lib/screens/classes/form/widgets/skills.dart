import 'package:flutter/material.dart';
import 'package:chaos_control/models/class_skill.dart';
import 'package:chaos_control/models/skill.dart';
import 'package:chaos_control/screens/classes/form/class_form_model.dart';
import 'package:chaos_control/screens/classes/form/widgets/skill_dialog.dart';
import 'package:chaos_control/screens/classes/form/widgets/skill_tile.dart';
import 'package:provider/provider.dart';

class ClassFormSkills extends StatelessWidget {
  const ClassFormSkills({super.key});

  @override
  Widget build(BuildContext context) {
    final model = context.read<ClassFormModel>();
    final classId = context.select<ClassFormModel, String>(
      (model) => model.record.id,
    );
    final skills = context.select<ClassFormModel, List<Skill>>(
      (model) => model.allSkills,
    );
    final selectedSkills = context.select<ClassFormModel, List<ClassSkill>>(
      (model) => model.selectedClassSkills,
    );
    final setSelectedSkills = model.setSelectedClassSkills;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text('Навыки', style: Theme.of(context).textTheme.titleMedium),
            IconButton(
              onPressed: () => showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                builder: (context) => ClassFormSkillDialog(
                  onConfirm: (skls) => setSelectedSkills(skls),
                  classId: classId,
                  selectedSkills: selectedSkills,
                ),
              ),
              icon: const Icon(Icons.add),
            ),
          ],
        ),
        const SizedBox(height: 8),
        SizedBox(
          height: 300,
          child: ListView(
            children: [
              if (selectedSkills.isEmpty)
                Text(
                  'Навыки не добавлены',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context).hintColor,
                  ),
                ),
              ...selectedSkills.map((reward) {
                Skill? skill;
                skill = skills.firstWhere((skl) => skl.id == reward.skillId);

                return ClassFormSkillTile(
                  title: skill.title,
                  selected: true,
                  focused: false,
                );
              }),
            ],
          ),
        ),
      ],
    );
  }
}
