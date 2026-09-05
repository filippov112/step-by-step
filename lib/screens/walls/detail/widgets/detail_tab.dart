import 'package:chaos_control/models/enums/wall_difficulty.dart';
import 'package:chaos_control/models/enums/wall_status.dart';
import 'package:chaos_control/screens/walls/detail/wall_detail_model.dart';
import 'package:chaos_control/screens/walls/detail/widgets/detail_price_card.dart';
import 'package:chaos_control/services/datetool.dart';
import 'package:chaos_control/services/wall_calculator.dart';
import 'package:chaos_control/widgets/common/custom_card_block.dart';
import 'package:chaos_control/widgets/common/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// Вкладка деталей
class WallDetailDetailTab extends StatelessWidget {
  const WallDetailDetailTab({super.key});

  @override
  Widget build(BuildContext context) {
    final target = context.select<WallDetailModel, String>(
      (model) => model.wall.target,
    );
    final diff = context.select<WallDetailModel, WallDiff>(
      (model) => model.wall.difficulty,
    );
    final status = context.select<WallDetailModel, WallStatus>(
      (model) => model.wall.status,
    );
    final created = context.select<WallDetailModel, DateTime?>(
      (model) => model.wall.created,
    );
    final destroyed = context.select<WallDetailModel, DateTime?>(
      (model) => model.wall.destroyed,
    );
    final attempts = context.select<WallDetailModel, int>(
      (model) => model.attempts.length,
    );
    final focusColor = Theme.of(context).focusColor;

    final successPrice = WallCalculator.getSuccesPrice(diff, attempts, status);
    final failurePrice = WallCalculator.getFailurePrice(diff, attempts, status);

    // Блок "Награда за успех"
    final successPriceWidget = WallDetailPriceCard(
      title: 'Успех',
      color: WallStatus.destroyed.color,
      icon: WallStatus.destroyed.icon,
      value: successPrice,
    );

    // Блок "Награда за провал"
    final failurePriceWidget = WallDetailPriceCard(
      title: 'Провал',
      color: WallStatus.retreated.color,
      icon: WallStatus.retreated.icon,
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
              CustomText('Разрушена:', color: WallStatus.destroyed.color),
              CustomText(
                DateTool.fullDateFormat(destroyed),
                weight: FontWeight.bold,
                color: WallStatus.destroyed.color,
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