import 'package:chaos_control/screens/projects/create/project_create_screen.dart';
import 'package:chaos_control/screens/projects/list/project_list_model.dart';
import 'package:chaos_control/widgets/common/custom_floating_action_button.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProjectListAddButton extends StatelessWidget {
  const ProjectListAddButton({super.key});

  @override
  Widget build(BuildContext context) {
    final model = context.read<ProjectListModel>();

    return CustomFloatingActionButton(
      openFormCreate: () => _create(context, model.loadData),
      tooltip: 'Создать проект',
    );
  }

  void _create(BuildContext context, VoidCallback loadCallback) {
    final group = context.read<ProjectListModel>().treeListModel.currentAddress;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom, // Важно!
          ),
          child: SizedBox(
            height: MediaQuery.of(context).size.height * 0.45,
            child: ProjectCreateScreen(group: group),
          ),
        );
      },
    ).then((_) {
      if (context.mounted) loadCallback();
    });
  }
}
