import 'package:chaos_control/models/project.dart';
import 'package:chaos_control/screens/targets/edit/target_edit_model.dart';
import 'package:chaos_control/widgets/common/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProjectTile extends StatelessWidget {
  final Function(Project?) selectCallback;
  final Project? project;
  const ProjectTile({
    super.key,
    required this.selectCallback,
    required this.project,
  });

  @override
  Widget build(BuildContext context) {
    final projectFilter = context.select<TargetEditModel, Project?>(
      (m) => m.selectedProject,
    );
    final color = projectFilter?.id != project?.id
        ? Theme.of(context).cardColor.withAlpha(100)
        : Theme.of(context).focusColor.withAlpha(40);
    final groupColor = Theme.of(context).colorScheme.onPrimary;

    final title = CustomText(
      project?.title ?? 'Без проекта',
      size: 17,
      padding: const EdgeInsets.symmetric(horizontal: 8),
      weight: project == null ? FontWeight.bold : FontWeight.normal,
    );
    final subtitle = CustomText(
      project?.group ?? '',
      size: 9,
      color: groupColor,
      padding: const EdgeInsets.symmetric(horizontal: 8),
    );

    return InkWell(
      onTap: () => selectCallback(project),
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: color,
          border: Border(
            bottom: BorderSide(color: Theme.of(context).dividerColor, width: 1),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [title, if (project != null) subtitle],
        ),
      ),
    );
  }
}