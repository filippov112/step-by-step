import 'package:chaos_control/models/project.dart';
import 'package:chaos_control/screens/walls/create/wall_create_model.dart';
import 'package:chaos_control/widgets/common/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class WallCreateInfo extends StatelessWidget {
  const WallCreateInfo({super.key});

  @override
  Widget build(BuildContext context) {
    final selectedProject = context.select<WallCreateModel, Project?>(
      (m) => m.selectedProject,
    );
    final selectedGroup = context.select<WallCreateModel, String>(
      (m) => m.selectedGroup,
    );

    final focusColor = Theme.of(context).focusColor;

    final project = selectedProject == null
        ? const SizedBox()
        : CustomText(
            selectedProject.title,
            size: 14,
            align: TextAlign.left,
            color: focusColor,
          );

    final group = selectedGroup.isEmpty
        ? const SizedBox()
        : CustomText(selectedGroup, size: 10, align: TextAlign.left);

    return Padding(
      padding: const EdgeInsetsGeometry.fromLTRB(8, 0, 8, 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [project, group],
      ),
    );
  }
}
