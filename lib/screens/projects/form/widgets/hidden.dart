// Поле чекбокса
import 'package:chaos_control/screens/projects/form/project_form_model.dart';
import 'package:chaos_control/widgets/form/checkbox.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProjectFormHidden extends StatelessWidget {

  const ProjectFormHidden({
    super.key,
  });

  @override
  Widget build(BuildContext context) {

    final hidden = context.select<ProjectFormModel,bool>((m) => m.selectedHidden);
    final setHidden = context.read<ProjectFormModel>().setHidden;

    return CustomCheckbox(
      label: 'Скрытый проект',
      initValue: hidden,
      setValue: setHidden,
    );
  }
}