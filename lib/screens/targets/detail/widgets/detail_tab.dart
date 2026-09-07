import 'package:chaos_control/models/enums/target_difficulty.dart';
import 'package:chaos_control/models/enums/target_status.dart';
import 'package:chaos_control/screens/targets/detail/target_detail_model.dart';
import 'package:chaos_control/screens/targets/detail/widgets/detail_price_card.dart';
import 'package:chaos_control/services/datetool.dart';
import 'package:chaos_control/services/target_calculator.dart';
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
    final diff = context.select<TargetDetailModel, TargetDiff>(
      (model) => model.target.difficulty,
    );
    final status = context.select<TargetDetailModel, TargetStatus>(
      (model) => model.target.status,
    );
    final created = context.select<TargetDetailModel, DateTime?>(
      (model) => model.target.created,
    );
    final destroyed = context.select<TargetDetailModel, DateTime?>(
      (model) => model.target.destroyed,
    );
    final tasks = context.select<TargetDetailModel, int>(
      (model) => model.tasks.length,
    );
    final focusColor = Theme.of(context).focusColor;

    final successPrice = TargetCalculator.getSuccesPrice(diff, tasks, status);
    final failurePrice = TargetCalculator.getFailurePrice(diff, tasks, status);

    // Блок "Награда за успех"
    final successPriceWidget = TargetDetailPriceCard(
      title: 'Успех',
      color: TargetStatus.destroyed.color,
      icon: TargetStatus.destroyed.icon,
      value: successPrice,
    );

    // Блок "Награда за провал"
    final failurePriceWidget = TargetDetailPriceCard(
      title: 'Провал',
      color: TargetStatus.retreated.color,
      icon: TargetStatus.retreated.icon,
      value: failurePrice,
    );

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

    // Строка "Сложность"
    final diffWidget = Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const CustomText('Сложность:'),
        CustomText(diff.name, color: diff.color, weight: FontWeight.bold),
      ],
    );

    // Строка "Создана"
    final createdWidget = Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const CustomText('Создана:'),
        CustomText(DateTool.fullDateFormat(created), weight: FontWeight.bold),
      ],
    );

    // Строка "Разрушена"
    final destroyedWidget = destroyed == null
        ? null
        : Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CustomText('Разрушена:', color: TargetStatus.destroyed.color),
              CustomText(
                DateTool.fullDateFormat(destroyed),
                weight: FontWeight.bold,
                color: TargetStatus.destroyed.color,
              ),
            ],
          );

    // Блок "Сложность, создана, разрушена"
    final otherInfoWidget = CustomCardBlock(
      child: Padding(
        padding: const EdgeInsetsGeometry.all(8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [diffWidget, createdWidget, ?destroyedWidget],
        ),
      ),
    );

    return Container(
      padding: EdgeInsets.all(12),
      child: ListView(
        children: [
          ?targetWidget,
          Row(
            children: [
              successPriceWidget,
              const SizedBox(width: 8),
              failurePriceWidget,
            ],
          ),
          otherInfoWidget,
        ],
      ),
    );
  }
}