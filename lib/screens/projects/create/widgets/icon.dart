import 'package:chaos_control/screens/projects/create/project_create_model.dart';
import 'package:flutter/material.dart';
import 'package:chaos_control/models/other/image.dart';
import 'package:chaos_control/widgets/form/custom_icon_picker.dart';
import 'package:provider/provider.dart';

class ProjectCreateIcon extends StatelessWidget {
  const ProjectCreateIcon({super.key});

  @override
  Widget build(BuildContext context) {
    final model = context.read<ProjectCreateModel>();
    var selectedIcon = context.select<ProjectCreateModel, CustomImageData?>(
      (model) => model.icon,
    );
    var setIcon = model.setIcon;

    // Иконка
    return Center(
      child: CustomIconPicker(
        size: 50,
        selectedIcon: selectedIcon,
        setIcon: setIcon,
        borderWidth: 3,
      ),
    );
  }
}