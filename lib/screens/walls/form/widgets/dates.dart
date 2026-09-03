import 'package:chaos_control/screens/walls/form/wall_form_model.dart';
import 'package:chaos_control/widgets/form/datetime_picker.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class WallFormDates extends StatelessWidget {

  const WallFormDates({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final model = context.read<WallFormModel>();
    final created = context.select<WallFormModel,DateTime?>((m) => m.created);
    final destroyed = context.select<WallFormModel,DateTime?>((m) => m.destroyed);
    final setCreated = model.setCreated;
    final setDestroyed = model.setDestroyed;

    return Column(
      children: [
      CustomDateTime(title: 'Создана:', callback: setCreated, value: created, dateOnly: true,),
      SizedBox(height: 12,),
      CustomDateTime(title: 'Разрушена:', callback: setDestroyed, value: destroyed, dateOnly: true,),
    ],);
  }
}