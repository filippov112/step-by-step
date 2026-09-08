import 'package:chaos_control/models/project.dart';
import 'package:flutter/material.dart';
import 'package:chaos_control/screens/targets/detail/target_detail_model.dart';
import 'package:chaos_control/widgets/common/custom_text.dart';
import 'package:provider/provider.dart';

class TargetDetailHeader extends StatelessWidget {
  const TargetDetailHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final model = context.read<TargetDetailModel>();
    var title = context.select<TargetDetailModel, String>(
      (model) => model.target.title,
    );
    final selectedProject = context.select<TargetDetailModel, Project?>(
      (m) => m.project,
    );
    final selectedGroup = context.select<TargetDetailModel, String>(
      (m) => m.target.group,
    );
    final favorite = context.select<TargetDetailModel, bool>(
      (m) => m.target.favorite,
    );

    final focusColor = Theme.of(context).focusColor;
    final disabledColor = Theme.of(context).disabledColor;
    final dividerColor = Theme.of(context).dividerColor;

    final favoriteIconColor = favorite
        ? focusColor
        : disabledColor.withAlpha(60);
    final favoriteBorderColor = favorite ? focusColor : dividerColor;

    final titleWidget = CustomText(
      title,
      size: 20,
      weight: const FontWeight(500),
    );

    final project = selectedProject == null
        ? const SizedBox()
        : CustomText(
            selectedProject.title,
            size: 14,
            align: TextAlign.left,
            color: focusColor,
          );

    final group = selectedGroup.isEmpty
        ? const SizedBox()
        : CustomText(selectedGroup, size: 10, align: TextAlign.left);

    final favoriteWidget = Container(
      margin: const EdgeInsets.symmetric(vertical: 6),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: favoriteBorderColor, width: 1),
      ),
      child: InkWell(
        onTap: () => model.setFavorite(!favorite),
        borderRadius: const BorderRadius.all(Radius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Center(child: Icon(Icons.star, size:18, color: favoriteIconColor)),
        ),
      ),
    );

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      child: Row(
        children: [
          Expanded(child:Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [titleWidget, project, group],
          ),),
          const SizedBox(width: 16),
          favoriteWidget
        ],
      ),
    );
  }
}
