import 'package:chaos_control/models/enums/target_difficulty.dart';
import 'package:chaos_control/screens/targets/create/target_create_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class TargetCreateFavorite extends StatelessWidget {
  const TargetCreateFavorite({super.key});

  @override
  Widget build(BuildContext context) {
    final diff = context.select<TargetCreateModel,TargetDiff>((m) => m.difficulty);
    final favorite = context.select<TargetCreateModel, bool>((m) => m.favorite);
    final setFavorite = context.read<TargetCreateModel>().setFavorite;

    final disabledColor = Theme.of(context).disabledColor;
    final dividerColor = Theme.of(context).dividerColor;
    final cardColor = Theme.of(context).cardColor;
    final focusColor = Theme.of(context).focusColor;
    final Gradient gradient = LinearGradient(
            transform: GradientRotation(0.7),
            colors: [diff.color.withValues(alpha: 0.5), cardColor],
            stops: [0, 0.2],
          );

    final color = favorite
        ? diff.color
        : disabledColor.withAlpha(60);

    final borderColor = favorite ? focusColor : dividerColor;

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6),
      decoration: BoxDecoration(
        gradient: gradient,
        borderRadius: const BorderRadius.all(Radius.circular(16)),
        border: Border.all(color: borderColor, width: 1),
      ),
      child: InkWell(
        onTap: () => setFavorite(!favorite),
        borderRadius: const BorderRadius.all(Radius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.all(11),
          child: Center(child: Icon(Icons.star, color: color)),
        ),
      ),
    );
  }
}
