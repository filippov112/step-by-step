import 'package:chaos_control/screens/targets/detail/target_detail_model.dart';
import 'package:chaos_control/widgets/common/custom_card_block.dart';
import 'package:chaos_control/widgets/common/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// Вкладка деталей
class TargetDetailDetailTab extends StatelessWidget {
  const TargetDetailDetailTab({super.key});

  @override
  Widget build(BuildContext context) {
    final target = context.select<TargetDetailModel, String>(
      (model) => model.target.desc,
    );
    // final tasks = context.select<TargetDetailModel, int>(
    //   (model) => model.tasks.length,
    // );
    final focusColor = Theme.of(context).focusColor;

    // final successPrice = TargetCalculator.getSuccesPrice(diff, tasks, status);

    // Блок "Награда за успех"
    // final successPriceWidget = TargetDetailPriceCard(
    //   title: 'Успех',
    //   color: TargetStatus.destroyed.color,
    //   icon: TargetStatus.destroyed.icon,
    //   value: successPrice,
    // );


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
      child: ListView(
        children: [
          ?targetWidget,
        ],
      ),
    );
  }
}