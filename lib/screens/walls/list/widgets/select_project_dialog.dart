import 'package:chaos_control/models/project.dart';
import 'package:chaos_control/screens/walls/list/wall_list_model.dart';
import 'package:chaos_control/screens/walls/list/widgets/project_tile.dart';
import 'package:chaos_control/widgets/common/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class WallListSelectProjectDialog extends StatefulWidget {
  const WallListSelectProjectDialog({super.key});

  @override
  State<WallListSelectProjectDialog> createState() =>
      _WallListSelectProjectDialogState();
}

class _WallListSelectProjectDialogState
    extends State<WallListSelectProjectDialog> {
  void _selectCallback(Project? project) {
    Navigator.pop(context, project);
  }

  @override
  Widget build(BuildContext context) {
    final projects = context.select<WallListModel, List<Project>>(
      (m) => m.projects,
    );

    final divider = Divider(
      height: 1,
      color: Theme.of(context).colorScheme.onSurface,
    );

    final header = const CustomText(
      'Выберите проект',
      size: 22,
      align: TextAlign.center,
      padding: EdgeInsets.all(7),
    );

    final list = Expanded(
      child: ListView.builder(
        itemCount: projects.length,
        itemBuilder: (context, index) {
          return ProjectTile(
            project: projects[index],
            selectCallback: _selectCallback,
          );
        },
      ),
    );

    final allProjects = ProjectTile(
      selectCallback: _selectCallback,
      project: null,
    );

    return Dialog(
      insetPadding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          header,
          divider,

          list,

          divider,
          allProjects,
          const SizedBox(height: 18),
        ],
      ),
    );
  }
}
