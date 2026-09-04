import 'package:chaos_control/models/project.dart';
import 'package:chaos_control/screens/walls/create/wall_create_screen.dart';
import 'package:chaos_control/screens/walls/list/wall_list_model.dart';
import 'package:chaos_control/widgets/common/custom_floating_action_button.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class WallListAddButton extends StatelessWidget {
  const WallListAddButton({super.key});

  @override
  Widget build(BuildContext context) {
    final model = context.read<WallListModel>();
    final group = context.select<WallListModel,String>((m) => m.treeListModel.currentAddress);
    final project = context.select<WallListModel,Project?>((m) => m.projectFilter);

    return  CustomFloatingActionButton(
      openFormCreate: () => _create(context, model.loadData, project, group),
      tooltip: 'Новая стена',
    );
  }

  void _create(BuildContext context, VoidCallback loadCallback, Project? selectedProject, String selectedGroup) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: false,
      builder: (context) => WallCreateScreen(project: selectedProject, group: selectedGroup,),
    ).then((_) {
      if (context.mounted) loadCallback();
    });
  }
}