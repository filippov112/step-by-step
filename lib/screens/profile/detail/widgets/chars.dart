import 'package:chaos_control/models/enums/characteristics.dart';
import 'package:chaos_control/services/numerictool.dart';
import 'package:chaos_control/services/spirit_calculator.dart';
import 'package:chaos_control/widgets/analysis/custom_progress_bar.dart';
import 'package:chaos_control/widgets/analysis/custom_radar_chart.dart';
import 'package:chaos_control/widgets/common/custom_text.dart';
import 'package:chartify/chartify.dart';
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
    final model = context.read<ProfileDetailModel>();

    final deltaColor = Colors.amber;

    final charTableMode = context.select<ProfileDetailModel, bool>(
      (m) => m.charTableMode,
    );
    final Map<Characteristic, int>? chars = context
        .select<ProfileDetailModel, Map<Characteristic, int>?>(
          (model) => model.chars,
        );

    final Map<Characteristic, int>? deltaChars = context
        .select<ProfileDetailModel, Map<Characteristic, int>?>(
          (model) => model.deltaChars,
        );

    final radarFull = CustomRadarChart(
      padding: EdgeInsets.all(8),
      labels: chars?.keys.map((k) => k.emoji).toList() ?? [],
      values: [
        if (!charTableMode)
          RadarSeries(
            name: 'Всего:',
            pointRadius: 2,
            values:
                chars?.values
                    .map((sf) => sf.toDouble())
                    .toList() ??
                [],
            color: Theme.of(context).focusColor,
          ),
        if (charTableMode)
          RadarSeries(
            name: 'За период:',
            pointRadius: 2,
            values:
                deltaChars?.values
                    .map((sf) => sf.toDouble())
                    .toList() ??
                [],
            color: deltaColor,
          ),
      ],
    );

    final modeButtons = Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        IconButton(
          icon: Icon(
            Icons.bar_chart,
            color: charTableMode
                ? Theme.of(context).disabledColor
                : Theme.of(context).focusColor,
            shadows: charTableMode ? null : [Shadow(color: Theme.of(context).focusColor, blurRadius: 6)],
          ),
          onPressed: () => model.setChartTableMode(false),
        ),
        IconButton(
          icon: Icon(
            Icons.add,
            color: !charTableMode
                ? Theme.of(context).disabledColor
                : deltaColor,
            shadows: !charTableMode ? null : [Shadow(color: deltaColor, blurRadius: 6)],
          ),
          onPressed: () => model.setChartTableMode(true),
        ),
      ],
    );

    final table = Container(
      padding: EdgeInsets.all(8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ...Characteristic.values.map((ch) {
            final sf = charTableMode ? (deltaChars?[ch] ?? 0) : (chars?[ch] ?? 0);
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
                      '${ch.displayName} (${ch.emoji})',
                      expanded: true,
                      size: 12,
                      padding: const EdgeInsets.only(bottom: 3, left: 12),
                    ),
                    CustomText(
                      '(${NumericTool.toThousandString(remains)} / ${NumericTool.toThousandString(requirements)} SF)',
                      size: 9,
                      color: charTableMode ? deltaColor : null,
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                    ),
                    CustomText(
                      NumericTool.toThousandString(points),
                      weight: FontWeight.bold,
                      color: charTableMode ? deltaColor : Theme.of(context).colorScheme.onPrimary,
                    ),
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
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          radarFull,
          Divider(color: Theme.of(context).dividerColor),
          modeButtons,
          table,
        ],
      ),
    );
  }
}
