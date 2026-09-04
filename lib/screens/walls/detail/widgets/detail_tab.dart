import 'package:chaos_control/models/enums/wall_difficulty.dart';
import 'package:chaos_control/models/enums/wall_status.dart';
import 'package:chaos_control/screens/walls/detail/wall_detail_model.dart';
import 'package:chaos_control/services/datetool.dart';
import 'package:chaos_control/services/numerictool.dart';
import 'package:chaos_control/services/wall_calculator.dart';
import 'package:chaos_control/widgets/common/custom_card_block.dart';
import 'package:chaos_control/widgets/common/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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

    final successPriceWidget = WallDetailPriceCard(
      title: 'Успех',
      color: WallStatus.destroyed.color,
      icon: WallStatus.destroyed.icon,
      value: successPrice,
    );

    final failurePriceWidget = WallDetailPriceCard(
      title: 'Провал',
      color: WallStatus.retreated.color,
      icon: WallStatus.retreated.icon,
      value: failurePrice,
    );

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

    final diffWidget = Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const CustomText('Уровень сложности:'),
        CustomText(diff.name, color: diff.color, weight: FontWeight.bold),
      ],
    );

    final createdWidget = Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const CustomText('Создана:'),
        CustomText(DateTool.fullDateFormat(created), weight: FontWeight.bold),
      ],
    );

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
              SizedBox(width: 8),
              failurePriceWidget,
            ],
          ),
          otherInfoWidget,
        ],
      ),
    );
  }
}

class WallDetailPriceCard extends StatelessWidget {
  final int value;
  final String title;
  final IconData icon;
  final Color color;

  const WallDetailPriceCard({
    super.key,
    required this.value,
    required this.title,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final backColor = color.withAlpha(20);
    final defaultTC = Theme.of(context).colorScheme.onPrimary;
    final textColor = Color.from(
      alpha: defaultTC.a,
      red: (6 * defaultTC.r + color.r) / 7,
      green: (6 * defaultTC.g + color.g) / 7,
      blue: (6 * defaultTC.b + color.b) / 7,
    );
    return Expanded(
      child: CustomCardBlock(
        title: title,
        icon: icon,
        backColor: backColor,
        iconColor: color,
        textColor: textColor,
        borderColor: color,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            CustomText(
              NumericTool.toThousandString(value),
              size: 24,
              weight: const FontWeight(500),
            ),
            const CustomText(
              'SF',
              padding: EdgeInsets.only(left: 4, bottom: 4),
            ),
          ],
        ),
      ),
    );
  }
}
