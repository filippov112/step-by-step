import 'package:chaos_control/screens/projects/create/project_create_model.dart';
import 'package:chaos_control/screens/projects/edit/project_edit_model.dart';
import 'package:chaos_control/widgets/common/custom_tile.dart';
import 'package:chaos_control/widgets/form/checkbox.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProjectCreateHidden extends StatelessWidget {
  const ProjectCreateHidden({super.key});

  @override
  Widget build(BuildContext context) {
    final hidden = context.select<ProjectCreateModel, bool>((m) => m.hidden);
    final setHidden = context.read<ProjectCreateModel>().setHidden;

    final bColor = hidden ? Theme.of(context).disabledColor 
            : Theme.of(context).focusColor;
    return CustomTile(
      padding: 12,
      borderRadius: 8,
      borderColor: bColor,
      callback: () => setHidden(!hidden),
      child: Center(
        child: Icon(
          hidden ? Icons.visibility_off : Icons.visibility,
          color: bColor,
        ),
      ),
    );
  }
}
