import 'package:flutter/material.dart';
import 'package:chaos_control/screens/projects/detail/project_detail_model.dart';
import 'package:chaos_control/widgets/common/custom_text.dart';
import 'package:provider/provider.dart';

class ProjectDetailTitle extends StatelessWidget {
  const ProjectDetailTitle({super.key});

  @override
  Widget build(BuildContext context) {
    var title = context.select<ProjectDetailModel, String>(
      (model) => model.project.title,
    );

    return CustomText(
      title,
      size: 22,
      align: TextAlign.center,
      lines: null,
      weight: FontWeight.bold,
      overflow: TextOverflow.visible,
    );
  }
}
