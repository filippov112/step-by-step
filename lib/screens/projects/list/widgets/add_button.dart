import 'package:chaos_control/screens/projects/form/project_form_screen.dart';
import 'package:chaos_control/screens/projects/list/project_list_model.dart';
import 'package:chaos_control/widgets/common/custom_floating_action_button.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProjectListAddButton extends StatelessWidget {
  const ProjectListAddButton({super.key});

  @override
  Widget build(BuildContext context) {
    final model = context.read<ProjectListModel>();

    return  CustomFloatingActionButton(
      openFormCreate: () => _create(context, model.loadData),
      tooltip: 'Создать проект',
    );
  }

  void _create(BuildContext context, VoidCallback loadCallback) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => ProjectFormScreen()),
    ).then((_) {
      if (context.mounted) loadCallback();
    });
  }
}