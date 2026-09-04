import 'package:chaos_control/models/enums/wall_difficulty.dart';
import 'package:chaos_control/models/project.dart';
import 'package:flutter/material.dart';
import 'package:chaos_control/screens/walls/detail/wall_detail_model.dart';
import 'package:chaos_control/widgets/common/custom_text.dart';
import 'package:provider/provider.dart';

class WallDetailHeader extends StatelessWidget {
  const WallDetailHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final model = context.read<WallDetailModel>();
    var title = context.select<WallDetailModel, String>(
      (model) => model.wall.title,
    );
    final selectedProject = context.select<WallDetailModel, Project?>(
      (m) => m.project,
    );
    final selectedGroup = context.select<WallDetailModel, String>(
      (m) => m.wall.group,
    );
    final diff = context.select<WallDetailModel, WallDiff>(
      (m) => m.wall.difficulty,
    );
    final favorite = context.select<WallDetailModel, bool>(
      (m) => m.wall.favorite,
    );

    final focusColor = Theme.of(context).focusColor;
    final disabledColor = Theme.of(context).disabledColor;
    final dividerColor = Theme.of(context).dividerColor;
    final cardColor = Theme.of(context).cardColor;

    final Gradient gradient = LinearGradient(
      transform: GradientRotation(0.7),
      colors: [diff.color.withValues(alpha: 0.5), cardColor],
      stops: [0, 0.2],
    );
    final favoriteIconColor = favorite
        ? diff.color
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
      decoration: BoxDecoration(gradient: gradient),
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
