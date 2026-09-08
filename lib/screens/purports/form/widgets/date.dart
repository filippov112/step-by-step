import 'package:flutter/material.dart';
import 'package:chaos_control/screens/purports/form/purport_form_model.dart';
import 'package:chaos_control/widgets/form/datetime_picker.dart';
import 'package:provider/provider.dart';

class PurportFormDate extends StatelessWidget {
  const PurportFormDate({super.key});

  @override
  Widget build(BuildContext context) {
    final selectedDate = context.select<PurportFormModel, DateTime?>(
      (model) => model.selectedDate,
    );
    final model = context.read<PurportFormModel>();
    final setDate = model.setDate;

    return CustomDateTime(callback: setDate, value: selectedDate, dateOnly: true,);
  }
}
