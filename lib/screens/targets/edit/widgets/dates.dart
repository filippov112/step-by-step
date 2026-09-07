import 'package:chaos_control/screens/targets/edit/target_edit_model.dart';
import 'package:chaos_control/widgets/form/datetime_picker.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class TargetEditDates extends StatelessWidget {

  const TargetEditDates({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final model = context.read<TargetEditModel>();
    final created = context.select<TargetEditModel,DateTime?>((m) => m.created);
    final destroyed = context.select<TargetEditModel,DateTime?>((m) => m.destroyed);
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