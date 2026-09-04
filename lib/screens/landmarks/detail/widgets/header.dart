import 'package:chaos_control/tools/datetool.dart';
import 'package:flutter/material.dart';
import 'package:chaos_control/models/enums/achiev_rar.dart';
import 'package:chaos_control/models/other/image.dart';
import 'package:chaos_control/screens/landmarks/detail/achievement_details_model.dart';
import 'package:chaos_control/widgets/common/custom_card_block.dart';
import 'package:chaos_control/widgets/common/custom_image_icon.dart';
import 'package:chaos_control/widgets/common/custom_text.dart';
import 'package:provider/provider.dart';

class AchiHeader extends StatelessWidget {
  const AchiHeader({super.key});

  @override
  Widget build(BuildContext context) {
    var title = context.select<AchievementDetailsModel, String>(
      (model) => model.achievement.title,
    );
    var icon = context.select<AchievementDetailsModel, CustomImageData?>(
      (model) => model.achievement.icon,
    );
    var date = context.select<AchievementDetailsModel, DateTime?>(
      (model) => model.achievement.date,
    );
    var rarity = context.select<AchievementDetailsModel, AchievRar>(
      (model) => model.achievement.rarity,
    );
  

    return CustomCardBlock(
      child: Column(
        children: [
          // Иконка
          CustomImageIcon(
            icon,
            altIcon: Icons.emoji_events,
            width: 60,
            height: 60,
            color: rarity.color,
            borderColor: rarity.color,
            borderWidth: 2,
          ),

          // Заголовок
          const SizedBox(height: 16),
          CustomText(
            title,
            size: 16,
            align: TextAlign.center,
            lines: null,
            weight: FontWeight.bold,
            overflow: TextOverflow.visible,
          ),

          // Дата получения
          if (date != null) ...{
            const SizedBox(height: 16),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.calendar_today, size: 14),
                const SizedBox(width: 8),
                CustomText(DateTool.fullDateFormat(date)),
              ],
            ),
          },
        ],
      ),
    );
  }
}
