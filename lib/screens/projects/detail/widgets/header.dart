import 'package:chaos_control/widgets/common/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:chaos_control/models/other/image.dart';
import 'package:chaos_control/screens/projects/detail/project_detail_model.dart';
import 'package:chaos_control/widgets/common/custom_image_icon.dart';
import 'package:provider/provider.dart';

class ProjectDetailHeader extends StatelessWidget {
  const ProjectDetailHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final icon = context.select<ProjectDetailModel, CustomImageData?>(
      (model) => model.project.icon,
    );
    final title = context.select<ProjectDetailModel, String>(
      (model) => model.project.title,
    );
    final hidden = context.select<ProjectDetailModel,bool>((m) => m.project.hidden);

    final iconWidget = CustomImageIcon(
      icon,
      altIcon: Icons.workspaces,
      width: 60,
      height: 60,
      // color: rarity.color,
      borderWidth: 2,
    );

    final titleWidget = CustomText(
      title,
      size: 18,
      padding: EdgeInsets.symmetric(horizontal: 8),
      align: TextAlign.left,
      lines: 1,
    );

    final hiddenWidget = hidden ? Padding(
      padding: EdgeInsetsGeometry.symmetric(horizontal: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(Icons.remove_red_eye, size: 14),
          CustomText(
            'проект скрыт',
            size: 12,
            expanded: true,
            padding: EdgeInsets.only(left: 4, bottom: 4),
          ),
        ],
      ),
    ) : null;

    return Container(
      decoration: BoxDecoration(color: Theme.of(context).cardColor),
      padding: EdgeInsetsGeometry.all(8),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        children: [
          iconWidget,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              children: [titleWidget, ?hiddenWidget],
            ),
          ),
        ],
      ),
    );
  }
}
