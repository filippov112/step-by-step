import 'package:flutter/material.dart';
import 'package:chaos_control/screens/projects/detail/project_detail_model.dart';
import 'package:chaos_control/widgets/common/custom_text.dart';
import 'package:provider/provider.dart';

class ProjectDetailInfoTab extends StatelessWidget {
  const ProjectDetailInfoTab({super.key});

  @override
  Widget build(BuildContext context) {
    var description = context.select<ProjectDetailModel, String>(
      (model) => model.project.target,
    );

    if (description.isNotEmpty) {
      return Container(
        padding: EdgeInsets.all(12),
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
