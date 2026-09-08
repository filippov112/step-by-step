import 'package:chaos_control/screens/projects/edit/project_edit_model.dart';
import 'package:chaos_control/widgets/form/checkbox.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProjectEditHidden extends StatelessWidget {

  const ProjectEditHidden({
    super.key,
  });

  @override
  Widget build(BuildContext context) {

    final hidden = context.select<ProjectEditModel,bool>((m) => m.hidden);
    final setHidden = context.read<ProjectEditModel>().setHidden;

    return CustomCheckbox(
      label: 'Скрытый проект',
      initValue: hidden,
      setValue: setHidden,
    );
  }
}