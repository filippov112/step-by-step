import 'package:flutter/material.dart';
import 'package:life_game/models/class_skill.dart';
import 'package:life_game/models/skill.dart';
import 'package:life_game/screens/classes/form/widgets/skill_dialog.dart';
import 'package:life_game/screens/classes/form/widgets/skill_tile.dart';


class SkillsSection extends StatelessWidget {

  final List<ClassSkill> selectedSkills;
  final Function(List<ClassSkill>) setSelectedSkills;
  final List<Skill> skills;
  final String classId;

  const SkillsSection({
    super.key,
    required this.selectedSkills, 
    required this.setSelectedSkills,
    required this.skills,
    required this.classId,
  });

  @override
  Widget build(BuildContext context) {

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              'Навыки',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            IconButton(
              onPressed: () => showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                builder: (context) => SkillDialog(
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
          height:300,
          child: 
          ListView(children: [
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
              
              return SkillTile(
                title: skill.title,
                selected: true,
                focused: false,
              );
            })
          ],)
        ),
      ],
    );
  }
  
}




