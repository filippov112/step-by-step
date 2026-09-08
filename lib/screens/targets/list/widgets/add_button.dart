import 'package:chaos_control/models/project.dart';
import 'package:chaos_control/screens/targets/create/target_create_screen.dart';
import 'package:chaos_control/screens/targets/list/target_list_model.dart';
import 'package:chaos_control/widgets/common/custom_floating_action_button.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class TargetListAddButton extends StatelessWidget {
  const TargetListAddButton({super.key});

  @override
  Widget build(BuildContext context) {
    final model = context.read<TargetListModel>();
    final group = context.select<TargetListModel, String>(
      (m) => m.treeListModel.currentAddress,
    );
    final project = context.select<TargetListModel, Project?>(
      (m) => m.projectFilter,
    );

    return CustomFloatingActionButton(
      openFormCreate: () => _create(context, model.loadData, project, group),
      tooltip: 'Новая цель',
    );
  }

  void _create(
    BuildContext context,
    VoidCallback loadCallback,
    Project? selectedProject,
    String selectedGroup,
  ) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: false,
      builder: (context) =>
          TargetCreateScreen(project: selectedProject, group: selectedGroup),
    ).then((_) {
      if (context.mounted) loadCallback();
    });
  }
}
