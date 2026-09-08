import 'package:chaos_control/models/enums/characteristics.dart';
import 'package:chaos_control/services/spirit_calculator.dart';
import 'package:chaos_control/widgets/analysis/custom_progress_bar.dart';
import 'package:chaos_control/widgets/analysis/custom_radar_chart.dart';
import 'package:chaos_control/widgets/common/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:chaos_control/screens/profile/detail/profile_detail_model.dart';
import 'package:chaos_control/widgets/common/custom_card_block.dart';
import 'package:provider/provider.dart';

// Характеристики игрока
class ProfileDetailChars extends StatefulWidget {
  const ProfileDetailChars({super.key});

  @override
  State<ProfileDetailChars> createState() => _ProfileDetailCharsState();
}

class _ProfileDetailCharsState extends State<ProfileDetailChars> {
  @override
  Widget build(BuildContext context) {
    final Map<Characteristics, int>? chars = context
        .select<ProfileDetailModel, Map<Characteristics, int>?>(
          (model) => model.chars,
        );

    final radar = CustomRadarChart(
      seriesName: 'Очки:',
      labels: chars?.keys.map((k) => k.emoji).toList() ?? [],
      values:
          chars?.values
              .map((sf) => SpiritCalculator.getCharPoints(sf).toDouble())
              .toList() ??
          [],
    );

    final table = Container(
      padding: EdgeInsets.all(8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ...Characteristics.values.map((ch) {
            final sf = chars?[ch] ?? 0;
            final points = SpiritCalculator.getCharPoints(sf);
            final remains = SpiritCalculator.getCharPointsRemains(sf);
            final requirements = SpiritCalculator.getCharPointsRequirements(sf);

            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  children: [
                    Icon(ch.icon, color: ch.color, size: 14),
                    CustomText(
                      ch.displayName,
                      expanded: true,
                      size: 12,
                      padding: const EdgeInsets.only(bottom: 3, left: 12),
                    ),
                    CustomText(
                      points.toString(),
                      weight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.onPrimary,
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                    ),
                    CustomText('($remains / $requirements)', size: 12,),
                  ],
                ),
                CustomProgressBar(
                  value: remains.toDouble(),
                  mainColor: ch.color,
                  height: 6,
                  backColor: ch.color.withAlpha(100),
                  maxValue: requirements.toDouble(),
                ),
                const SizedBox(height: 8),
              ],
            );
          }),
        ],
      ),
    );

    return CustomCardBlock(
      title: 'Характеристики',
      icon: Icons.bar_chart,
      child: Column(
        children: [
          radar,
          Divider(color: Theme.of(context).dividerColor),
          table,
        ],
      ),
    );
  }
}
