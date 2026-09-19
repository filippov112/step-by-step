import 'package:chaos_control/models/other/image.dart';
import 'package:chaos_control/widgets/common/custom_image_icon.dart';
import 'package:chaos_control/widgets/common/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:chaos_control/screens/purports/detail/purport_detail_model.dart';
import 'package:provider/provider.dart';

class PurportDetailHeader extends StatelessWidget {
  const PurportDetailHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final focusColor = Theme.of(context).focusColor;
    final title = context.select<PurportDetailModel, String?>(
      (m) => m.purport?.title,
    );
    final icon = context.select<PurportDetailModel, CustomImageData?>(
      (m) => m.purport?.icon,
    );
    final titleWidget = CustomText(
      title ?? '',
      size: 18,
      padding: EdgeInsets.symmetric(horizontal: 12),
      expanded: true,
      align: TextAlign.left,
      lines: 1,
    );

    final iconWidget = CustomImageIcon(icon, borderWidth: 1, borderColor: focusColor,);

    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor.withAlpha(150),
      ),
      padding: EdgeInsetsGeometry.all(8),
      child: Row(children: [iconWidget, titleWidget]),
    );
  }
}
