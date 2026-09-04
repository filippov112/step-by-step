import 'package:chaos_control/models/project.dart';
import 'package:chaos_control/screens/walls/edit/wall_edit_model.dart';
import 'package:chaos_control/screens/walls/edit/widgets/project_dialog_tile.dart';
import 'package:chaos_control/widgets/common/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class WallEditSelectProjectDialog extends StatefulWidget {
  const WallEditSelectProjectDialog({super.key});

  @override
  State<WallEditSelectProjectDialog> createState() =>
      _WallEditSelectProjectDialogState();
}

class _WallEditSelectProjectDialogState
    extends State<WallEditSelectProjectDialog> {
  void _selectCallback(Project? project) {
    Navigator.pop(context, project);
  }

  @override
  Widget build(BuildContext context) {
    final projects = context.select<WallEditModel, List<Project>>(
      (m) => m.projects,
    );

    final divider = Divider(
      height: 1,
      color: Theme.of(context).colorScheme.onSurface,
    );

    final header = const Center(
      child: CustomText(
        'Выберите проект',
        size: 22,
        align: TextAlign.center,
        padding: EdgeInsets.all(7),
      ),
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

    final close = Positioned(
      top: 2,
      right: 4,
      child: IconButton(
        icon: Icon(Icons.close, size: 20),
        onPressed: () => _selectCallback(null),
      ),
    );

    return Dialog(
      insetPadding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Stack(children: [header, close]),

          divider,

          list,
          const SizedBox(height: 18),
        ],
      ),
    );
  }
}
