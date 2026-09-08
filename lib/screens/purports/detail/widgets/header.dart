import 'package:chaos_control/services/datetool.dart';
import 'package:flutter/material.dart';
import 'package:chaos_control/models/enums/purport_type.dart';
import 'package:chaos_control/models/other/image.dart';
import 'package:chaos_control/screens/purports/detail/purport_details_model.dart';
import 'package:chaos_control/widgets/common/custom_card_block.dart';
import 'package:chaos_control/widgets/common/custom_image_icon.dart';
import 'package:chaos_control/widgets/common/custom_text.dart';
import 'package:provider/provider.dart';

class PurportDetailHeader extends StatelessWidget {
  const PurportDetailHeader({super.key});

  @override
  Widget build(BuildContext context) {
    var title = context.select<PurportDetailsModel, String>(
      (model) => model.purport.title,
    );
    var icon = context.select<PurportDetailsModel, CustomImageData?>(
      (model) => model.purport.icon,
    );
    var date = context.select<PurportDetailsModel, DateTime?>(
      (model) => model.purport.date,
    );
    var rarity = context.select<PurportDetailsModel, PurportType>(
      (model) => model.purport.type,
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
