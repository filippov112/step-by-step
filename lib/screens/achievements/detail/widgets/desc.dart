import 'package:flutter/material.dart';
import 'package:life_game/screens/achievements/detail/achievement_details_model.dart';
import 'package:life_game/widgets/common/custom_card_block.dart';
import 'package:life_game/widgets/common/custom_text.dart';
import 'package:provider/provider.dart';

class AchiDescription extends StatelessWidget {
  const AchiDescription({super.key});

  @override
  Widget build(BuildContext context) {
    var description = context.select<AchievementDetailsModel, String>(
      (model) => model.achievement.description,
    );

    return CustomCardBlock(
      child: Column(
        children: [
          if (description.isNotEmpty) ...{
            CustomText(
              description,
              lines: null,
              overflow: TextOverflow.visible,
            ),
          },
        ],
      ),
    );
  }
}
