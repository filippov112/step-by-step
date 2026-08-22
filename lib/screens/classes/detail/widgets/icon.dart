import 'package:flutter/material.dart';
import 'package:life_game/models/other/image.dart';
import 'package:life_game/screens/classes/detail/class_detail_model.dart';
import 'package:life_game/widgets/common/custom_image_icon.dart';
import 'package:provider/provider.dart';

class ClassDetailIcon extends StatelessWidget {
  const ClassDetailIcon({super.key});

  @override
  Widget build(BuildContext context) {
    var icon = context.select<ClassDetailModel, CustomImageData?>(
      (model) => model.record.icon,
    );

    return Center(
      child: CustomImageIcon(
        icon,
        altIcon: Icons.emoji_events,
        width: 60,
        height: 60,
        // color: rarity.color,
        borderWidth: 2,
      ),
    );
  }
}
