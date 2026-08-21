import 'package:flutter/material.dart';
import 'package:life_game/models/skill.dart';
import 'package:life_game/screens/classes/detail/class_detail_model.dart';
import 'package:life_game/screens/classes/detail/widgets/skill_tile.dart';
import 'package:life_game/widgets/common/custom_text.dart';
import 'package:provider/provider.dart';

class ClassDetailSkills extends StatelessWidget {
  const ClassDetailSkills({super.key});

  @override
  Widget build(BuildContext context) {
    final skills = context.select<ClassDetailModel, List<Skill>>(
      (model) => model.skills,
    );
    final skillTiles = skills.map((skill) {
      return ClassDetailSkillTile(skill: skill);
    });

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        
        CustomText(
          'Навыки',
          size: 18,
          color: Theme.of(context).colorScheme.onSurface,
          padding: EdgeInsets.fromLTRB(0, 0, 8, 8),
        ),

        Card(
          margin: EdgeInsetsGeometry.all(0),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [...skillTiles],
            ),
          ),
        ),
      ],
    );
  }
}
