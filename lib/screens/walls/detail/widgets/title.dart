import 'package:flutter/material.dart';
import 'package:chaos_control/screens/walls/detail/wall_detail_model.dart';
import 'package:chaos_control/widgets/common/custom_text.dart';
import 'package:provider/provider.dart';

class WallDetailTitle extends StatelessWidget {
  const WallDetailTitle({super.key});

  @override
  Widget build(BuildContext context) {
    var title = context.select<WallDetailModel, String>(
      (model) => model.wall.title,
    );
    return CustomText(
      title,
      size: 20,
      weight: const FontWeight(500),
      lines: 3,
      padding: EdgeInsets.all(8),
    );
  }
}
