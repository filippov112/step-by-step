import 'package:flutter/material.dart';
import 'package:chaos_control/models/other/image.dart';
import 'package:chaos_control/screens/projects/form/project_form_model.dart';
import 'package:chaos_control/widgets/form/custom_icon_picker.dart';
import 'package:provider/provider.dart';

class ProjectFormIcon extends StatelessWidget {
  const ProjectFormIcon({super.key});

  @override
  Widget build(BuildContext context) {
    final model = context.read<ProjectFormModel>();
    var selectedIcon = context.select<ProjectFormModel, CustomImageData?>(
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