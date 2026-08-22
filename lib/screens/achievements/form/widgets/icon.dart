import 'package:flutter/material.dart';
import 'package:life_game/models/enums/achiev_rar.dart';
import 'package:life_game/models/other/image.dart';
import 'package:life_game/screens/achievements/form/achievement_form_model.dart';
import 'package:life_game/widgets/form/custom_icon_picker.dart';
import 'package:provider/provider.dart';

class AchievFormIcon extends StatelessWidget {
  const AchievFormIcon({super.key});

  @override
  Widget build(BuildContext context) {
    final selectedIcon = context.select<AchievementFormModel, CustomImageData?>(
      (model) => model.selectedIcon,
    );
    final selectedRarity = context.select<AchievementFormModel, AchievRar>(
      (model) => model.selectedRarity,
    );
    final model = context.read<AchievementFormModel>();
    final setIcon = model.setIcon;

    // Иконка
    return Center(
      child: CustomIconPicker(
        selectedIcon: selectedIcon,
        setIcon: setIcon,
        borderWidth: 3,
        color: selectedRarity.color,
      ),
    );
  }
}
