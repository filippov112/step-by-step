import 'package:chaos_control/widgets/common/custom_card_block.dart';
import 'package:flutter/material.dart';
import 'package:chaos_control/screens/projects/detail/project_detail_model.dart';
import 'package:chaos_control/widgets/common/custom_text.dart';
import 'package:provider/provider.dart';

class ProjectDetailDetailTab extends StatelessWidget {
  const ProjectDetailDetailTab({super.key});

  @override
  Widget build(BuildContext context) {
    var target = context.select<ProjectDetailModel, String>(
      (model) => model.project.target,
    );

    final focusColor = Theme.of(context).focusColor;

    // Блок "Цель"
    final targetWidget = target.isEmpty
        ? null
        : CustomCardBlock(
            borderColor: focusColor,
            icon: Icons.center_focus_weak_rounded,
            title: 'Цель',
            child: CustomText(
              target,
              lines: null,
              overflow: TextOverflow.visible,
            ),
          );
      
    return Container(
      padding: EdgeInsets.all(12),
      child: ListView(children: [?targetWidget]),
    );
  }
}
