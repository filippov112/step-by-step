import 'package:chaos_control/models/project.dart';
import 'package:chaos_control/screens/walls/edit/wall_edit_model.dart';
import 'package:chaos_control/screens/walls/edit/widgets/project_dialog.dart';
import 'package:chaos_control/widgets/common/custom_card_block.dart';
import 'package:chaos_control/widgets/common/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class WallEditProject extends StatelessWidget {
  const WallEditProject({super.key});

  Future _openProjectDialog(
    BuildContext context,
    Function(Project?) callback,
  ) async {
    final selectedProject = await showDialog<Project?>(
      context: context,
      builder: (context) => const WallEditSelectProjectDialog(),
    );
    if (selectedProject != null) {
      callback.call(selectedProject);
    }
  }

  @override
  Widget build(BuildContext context) {
    final model = context.read<WallEditModel>();

    final selectedProject = context.select<WallEditModel, Project?>(
      (m) => m.selectedProject,
    );
    final setProject = model.setProject;

    final cardColor = Theme.of(context).cardColor.withAlpha(180);
    final focusColor = Theme.of(context).focusColor;
    final projectName = selectedProject == null ? '' : selectedProject.title;

    final radius = BorderRadius.circular(12);
    final border = Border.all(color: Theme.of(context).dividerColor, width: 1);

    final selectProjectWidget = InkWell(
      borderRadius: radius,
      onTap: () => _openProjectDialog(context, setProject),
      child: Container(
        decoration: BoxDecoration(
          color: cardColor,
          border: border,
          borderRadius: radius,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CustomText(
              projectName,
              size: 15,
              align: TextAlign.left,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              color: focusColor,
            ),
          ],
        ),
      ),
    );

    final resetButton = selectedProject == null
        ? null
        : Padding(
            padding: EdgeInsetsGeometry.only(left: 8),
            child: IconButton(
              icon: Icon(Icons.close),
              onPressed: () => setProject(null),
            ),
          );

    return CustomCardBlock(
      title: 'Проект',
      icon: Icons.workspaces,
      child: SizedBox(
        height: 40,
        child: Row(children: [Expanded(child:selectProjectWidget), ?resetButton]),
      ),
    );
  }
}
