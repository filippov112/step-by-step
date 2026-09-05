import 'package:chaos_control/screens/walls/edit/wall_edit_model.dart';
import 'package:chaos_control/widgets/form/datetime_picker.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class WallEditDates extends StatelessWidget {

  const WallEditDates({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final model = context.read<WallEditModel>();
    final created = context.select<WallEditModel,DateTime?>((m) => m.created);
    final destroyed = context.select<WallEditModel,DateTime?>((m) => m.destroyed);
    final setCreated = model.setCreated;
    final setDestroyed = model.setDestroyed;

    return Column(
      children: [
      CustomDateTime(label: 'Создана:', callback: setCreated, value: created, dateOnly: true,),
      SizedBox(height: 12,),
      CustomDateTime(label: 'Разрушена:', callback: setDestroyed, value: destroyed, dateOnly: true,),
    ],);
  }
}