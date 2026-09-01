import 'package:flutter/material.dart';
import 'package:chaos_control/screens/projects/detail/project_detail_model.dart';
import 'package:chaos_control/widgets/common/custom_text.dart';
import 'package:provider/provider.dart';

class ProjectDetailTarget extends StatelessWidget {
  const ProjectDetailTarget({super.key});

  @override
  Widget build(BuildContext context) {
    var description = context.select<ProjectDetailModel, String>(
      (model) => model.project.target,
    );

    if (description.isNotEmpty) {
      return Container(
        height: 150,
        padding: EdgeInsets.only(bottom: 16),
        child: ListView(
          children: [
            CustomText(
              description,
              lines: null,
              overflow: TextOverflow.visible,
            ),
          ],
        ),
      );
    }

    return const SizedBox();
  }
}
