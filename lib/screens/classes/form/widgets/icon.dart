import 'package:flutter/material.dart';
import 'package:life_game/screens/classes/form/class_form_model.dart';
import 'package:life_game/widgets/dialogs/custom_icon_picker.dart';
import 'package:provider/provider.dart';

class ClassFormIcon extends StatelessWidget {
  const ClassFormIcon({super.key});

  @override
  Widget build(BuildContext context) {
    final model = context.read<ClassFormModel>();
    var selectedIcon = context.select<ClassFormModel, String?>(
      (model) => model.selectedIcon,
    );
    var setIcon = model.setIcon;

    // Иконка
    return Center(
      child: CustomIconPicker(
        iconPath: selectedIcon,
        setIcon: setIcon,
        borderWidth: 3,
      ),
    );
  }
}