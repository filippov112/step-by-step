import 'package:flutter/material.dart';
import 'package:chaos_control/models/enums/purport_type.dart';
import 'package:chaos_control/models/other/image.dart';
import 'package:chaos_control/screens/purports/form/purport_form_model.dart';
import 'package:chaos_control/widgets/form/custom_icon_picker.dart';
import 'package:provider/provider.dart';

class PurportFormIcon extends StatelessWidget {
  const PurportFormIcon({super.key});

  @override
  Widget build(BuildContext context) {
    final selectedIcon = context.select<PurportFormModel, CustomImageData?>(
      (model) => model.selectedIcon,
    );
    final selectedRarity = context.select<PurportFormModel, PurportType>(
      (model) => model.selectedRarity,
    );
    final model = context.read<PurportFormModel>();
    final setIcon = model.setIcon;

    // Иконка
    return Center(
      child: CustomIconPicker(
        selectedIcon: selectedIcon,
        setIcon: setIcon,
        borderWidth: 3,
        color: selectedRarity.color,
      ),
    );
  }
}
