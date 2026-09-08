import 'package:flutter/material.dart';
import 'package:chaos_control/models/other/image.dart';
import 'package:chaos_control/screens/projects/edit/project_edit_model.dart';
import 'package:chaos_control/widgets/form/custom_icon_picker.dart';
import 'package:provider/provider.dart';

class ProjectEditIcon extends StatelessWidget {
  const ProjectEditIcon({super.key});

  @override
  Widget build(BuildContext context) {
    final model = context.read<ProjectEditModel>();
    var selectedIcon = context.select<ProjectEditModel, CustomImageData?>(
      (model) => model.icon,
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