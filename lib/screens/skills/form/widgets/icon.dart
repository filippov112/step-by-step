import 'package:flutter/material.dart';
import 'package:chaos_control/models/enums/skill_rang.dart';
import 'package:chaos_control/models/other/image.dart';
import 'package:chaos_control/screens/skills/form/skill_form_model.dart';
import 'package:chaos_control/widgets/form/custom_icon_picker.dart';
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
