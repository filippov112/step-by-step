import 'package:chaos_control/services/numerictool.dart';
import 'package:chaos_control/widgets/common/custom_card_block.dart';
import 'package:chaos_control/widgets/common/custom_text.dart';
import 'package:flutter/material.dart';

class TargetDetailPriceCard extends StatelessWidget {
  final int value;
  final String title;
  final IconData icon;
  final Color color;

  const TargetDetailPriceCard({
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
