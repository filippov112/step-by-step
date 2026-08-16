import 'package:flutter/material.dart';
import 'package:life_game/models/enums/skill_rang.dart';
import 'package:life_game/models/skill.dart';
import 'package:life_game/models/tag.dart';
import 'package:life_game/themes/solo_leveling_theme.dart';
import 'package:life_game/widgets/common/custom_image_icon.dart';
import 'package:life_game/widgets/common/custom_text.dart';

class SkillTile extends StatelessWidget {
  final Skill skill;
  final List<Tag> tags;
  final VoidCallback openDetails;

  const SkillTile({super.key, 
    required this.skill, 
    required this.tags,
    required this.openDetails
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 4),
      child: InkWell(
        borderRadius: const BorderRadius.all(Radius.circular(12)),
        onTap:  openDetails,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsetsGeometry.fromLTRB(12,12,0,12), 
              child: CustomImageIcon(
                skill.icon, 
                icon: Icons.star_border, 
                color: skill.rang.color, 
                width: 44, height: 44
              ),
            ),
            CustomText(
              skill.title, 
              weight: FontWeight(400), 
              size: 16, 
              lines: 2,
              padding: const EdgeInsets.all(12),
              expanded: true,
            ),
            Container(
              margin: const EdgeInsets.fromLTRB(0,12,12,12),
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Theme.of(context).dividerColor.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: CustomText(
                '${skill.level}',
                size: 20,
                weight: FontWeight.w600,
              ),
            ),
          ]
        ),
      )
    );
  }
}