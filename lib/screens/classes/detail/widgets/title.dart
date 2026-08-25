import 'package:flutter/material.dart';
import 'package:chaos_control/screens/classes/detail/class_detail_model.dart';
import 'package:chaos_control/widgets/common/custom_text.dart';
import 'package:provider/provider.dart';

class ClassDetailTitle extends StatelessWidget {
  const ClassDetailTitle({super.key});

  @override
  Widget build(BuildContext context) {
    var title = context.select<ClassDetailModel, String>(
      (model) => model.record.title,
    );

    return CustomText(
      title,
      size: 22,
      align: TextAlign.center,
      lines: null,
      weight: FontWeight.bold,
      overflow: TextOverflow.visible,
    );
  }
}
