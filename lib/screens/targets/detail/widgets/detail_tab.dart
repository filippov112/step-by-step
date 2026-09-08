import 'package:chaos_control/models/enums/characteristics.dart';
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
    final desc = context.select<TargetDetailModel, String>(
      (model) => model.target.desc,
    );
    final chars = context.select<TargetDetailModel, Map<Characteristics, int>>(
      (model) => model.target.chars,
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

    // Блок "Описание"
    final descWidget = desc.isEmpty
        ? null
        : CustomCardBlock(
            borderColor: focusColor,
            icon: Icons.description,
            title: 'Описание',
            child: CustomText(
              desc,
              lines: null,
              overflow: TextOverflow.visible,
            ),
          );

    // Блок "Распределение опыта"
    final charsBlock = CustomCardBlock(
      borderColor: focusColor,
      icon: Icons.bar_chart,
      title: 'Распределение',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ...Characteristics.values.map(
            (c) => Padding(
              padding: const EdgeInsetsGeometry.symmetric(horizontal: 8),
              child:Row(
              children: [
                Icon(c.icon, color: c.color, size: 14,),
                CustomText(c.displayName, expanded: true, padding: const EdgeInsets.only(left: 12, bottom: 3), size: 12),
                CustomText('${chars[c]} %', weight: FontWeight.bold),
              ],
            ),)
          ),
        ],
      ),
    );

    return Container(
      padding: EdgeInsets.all(12),
      child: ListView(children: [?descWidget, charsBlock]),
    );
  }
}
