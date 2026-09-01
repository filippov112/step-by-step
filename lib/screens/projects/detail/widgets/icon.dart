import 'package:flutter/material.dart';
import 'package:chaos_control/models/other/image.dart';
import 'package:chaos_control/screens/projects/detail/project_detail_model.dart';
import 'package:chaos_control/widgets/common/custom_image_icon.dart';
import 'package:provider/provider.dart';

class ProjectDetailIcon extends StatelessWidget {
  const ProjectDetailIcon({super.key});

  @override
  Widget build(BuildContext context) {
    var icon = context.select<ProjectDetailModel, CustomImageData?>(
      (model) => model.project.icon,
    );

    return Center(
      child: CustomImageIcon(
        icon,
        altIcon: Icons.star,
        width: 60,
        height: 60,
        // color: rarity.color,
        borderWidth: 2,
      ),
    );
  }
}
