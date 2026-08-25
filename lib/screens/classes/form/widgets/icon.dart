import 'package:flutter/material.dart';
import 'package:chaos_control/models/other/image.dart';
import 'package:chaos_control/screens/classes/form/class_form_model.dart';
import 'package:chaos_control/widgets/form/custom_icon_picker.dart';
import 'package:provider/provider.dart';

class ClassFormIcon extends StatelessWidget {
  const ClassFormIcon({super.key});

  @override
  Widget build(BuildContext context) {
    final model = context.read<ClassFormModel>();
    var selectedIcon = context.select<ClassFormModel, CustomImageData?>(
      (model) => model.selectedIcon,
    );
    var setIcon = model.setIcon;

    // Иконка
    return Center(
      child: CustomIconPicker(
        selectedIcon: selectedIcon,
        setIcon: setIcon,
        borderWidth: 3,
      ),
    );
  }
}