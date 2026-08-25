import 'package:flutter/material.dart';
import 'package:chaos_control/screens/achievements/form/achievement_form_model.dart';
import 'package:chaos_control/widgets/form/datetime_picker.dart';
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

    return CustomDateTime(callback: setDate, value: selectedDate, dateOnly: true,);
  }
}
