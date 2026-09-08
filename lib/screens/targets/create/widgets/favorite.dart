import 'package:chaos_control/screens/targets/create/target_create_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class TargetCreateFavorite extends StatelessWidget {
  const TargetCreateFavorite({super.key});

  @override
  Widget build(BuildContext context) {
    final favorite = context.select<TargetCreateModel, bool>((m) => m.favorite);
    final setFavorite = context.read<TargetCreateModel>().setFavorite;

    final disabledColor = Theme.of(context).disabledColor;
    final dividerColor = Theme.of(context).dividerColor;
    final focusColor = Theme.of(context).focusColor;


    final color = favorite
        ? focusColor
        : disabledColor.withAlpha(60);

    final borderColor = favorite ? focusColor : dividerColor;

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6),
      decoration: BoxDecoration(
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
