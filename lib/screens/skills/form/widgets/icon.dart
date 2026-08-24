import 'package:flutter/material.dart';
import 'package:life_game/models/enums/skill_rang.dart';
import 'package:life_game/models/other/image.dart';
import 'package:life_game/screens/skills/form/skill_form_model.dart';
import 'package:life_game/widgets/form/custom_icon_picker.dart';
import 'package:provider/provider.dart';

class SkillFormIcon extends StatelessWidget {
  const SkillFormIcon({super.key});

  @override
  Widget build(BuildContext context) {
    final iconPath = context.select<SkillFormModel, CustomImageData?>(
      (model) => model.icon,
    );
    final rang = context.select<SkillFormModel, SkillRang>(
      (model) => model.rang,
    );
    final setIcon = context.read<SkillFormModel>().setIcon;

    return CustomIconPicker(
      selectedIcon: iconPath,
      setIcon: setIcon,
      borderWidth: 3,
      color: rang.color,
    );
  }
}
