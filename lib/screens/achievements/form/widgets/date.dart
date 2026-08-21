import 'package:flutter/material.dart';
import 'package:life_game/screens/achievements/form/achievement_form_model.dart';
import 'package:life_game/widgets/common/custom_text.dart';
import 'package:life_game/widgets/common/custom_tile.dart';
import 'package:life_game/widgets/dialogs/select_date_only.dart';
import 'package:provider/provider.dart';

class AchievFormDate extends StatelessWidget {
  const AchievFormDate({super.key});

  @override
  Widget build(BuildContext context) {
    final selectedDate = context.select<AchievementFormModel, DateTime?>(
      (model) => model.selectedDate,
    );
    final model = context.read<AchievementFormModel>();
    final setDate = model.setDate;

    return CustomTile(
      callback: () async {
        final result = await selectDateOnly(
          context,
          selectedDate ?? DateTime.now(),
        );
        setDate(result);
      },
      padding: 16,
      borderRadius: 16,
      children: [
        const Icon(Icons.event),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const CustomText('Дата'),
              CustomText(
                selectedDate != null
                    ? '${selectedDate.day}.${selectedDate.month}.${selectedDate.year}'
                    : '',
              ),
            ],
          ),
        ),
        if (selectedDate != null)
          IconButton(onPressed: () => setDate(null), icon: Icon(Icons.close)),
      ],
    );
  }
}
