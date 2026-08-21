import 'package:flutter/material.dart';
import 'package:life_game/models/enums/skill_rang.dart';
import 'package:life_game/models/skill.dart';

class ClassDetailSkillTile extends StatelessWidget {
  final Skill skill;
  const ClassDetailSkillTile({super.key, required this.skill});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        contentPadding: EdgeInsetsGeometry.all(10),
        leading: Container(
          width: 40,
          height: 40,
          margin: EdgeInsetsGeometry.fromLTRB(8, 0, 0, 0),
          decoration: BoxDecoration(
            color: skill.rang.color.withValues(alpha: 0.2),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Center(
            child: Text(
              skill.rang.name,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: skill.rang.color,
              ),
            ),
          ),
        ),
        title: Text(
          skill.title,
          style: TextStyle(
            decoration: null,
            color: Theme.of(context).textTheme.bodyMedium?.color,
          ),
        ),
      ),
    );
  }
}
