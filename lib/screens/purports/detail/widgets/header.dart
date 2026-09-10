import 'package:chaos_control/widgets/common/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:chaos_control/screens/purports/detail/purport_detail_model.dart';
import 'package:provider/provider.dart';

class PurportDetailHeader extends StatelessWidget {
  const PurportDetailHeader({super.key});

  @override
  Widget build(BuildContext context) {

    final title = context.select<PurportDetailModel, String?>(
      (model) => model.purport?.title,
    );
    final titleWidget = CustomText(
      title ?? '',
      size: 18,
      padding: EdgeInsets.symmetric(horizontal: 8),
      align: TextAlign.left,
      lines: 1,
    );

    return Container(
      decoration: BoxDecoration(color: Theme.of(context).cardColor),
      padding: EdgeInsetsGeometry.all(8),
      child: titleWidget
    );
  }
}
