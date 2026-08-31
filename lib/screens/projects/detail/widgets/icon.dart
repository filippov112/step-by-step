import 'package:flutter/material.dart';
import 'package:chaos_control/models/other/image.dart';
import 'package:chaos_control/screens/projects/detail/class_detail_model.dart';
import 'package:chaos_control/widgets/common/custom_image_icon.dart';
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
