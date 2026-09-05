import 'package:chaos_control/services/datetool.dart';
import 'package:chaos_control/services/numerictool.dart';
import 'package:flutter/material.dart';
import 'package:chaos_control/widgets/common/custom_text.dart';
import 'package:chaos_control/widgets/common/custom_tile.dart';
import 'package:chaos_control/widgets/dialogs/select_date_only.dart';
import 'package:chaos_control/widgets/dialogs/select_date_time.dart';

class CustomDateTime extends StatelessWidget {
  final DateTime? value;
  final Function(DateTime?) callback;
  final bool dateOnly;
  final String? label;

  const CustomDateTime({
    super.key,
    required this.callback,
    required this.value,
    this.dateOnly = false,
    this.label,
  });

  Future _openDialog(BuildContext context) async {
    final today = DateTool.today();
    final result = dateOnly
        ? await selectDateOnly(context, value ?? today)
        : await selectDateTime(context, value ?? today);
    if (result != null) {
      callback(result);
    }
  }

  @override
  Widget build(BuildContext context) {
    final displayDateOnly = DateTool.shortDateFormat(value);
    final displayTime =
        '${NumericTool.toZeroFormat(value?.hour ?? 0, 2)}:${NumericTool.toZeroFormat(value?.minute ?? 0, 2)}';

    final displayValue = value != null
        ? (dateOnly ? displayDateOnly : '$displayDateOnly $displayTime')
        : '';

    return CustomTile(
      callback: () => _openDialog(context),
      padding: 8,
      borderRadius: 12,
      child: Row(
        children: [
          const Icon(Icons.event),
          const SizedBox(width: 12),

          if (label != null)
            CustomText(
              label!,
              size: 14,
              padding: const EdgeInsets.only(right: 8),
            ),
          CustomText(
            displayValue,
            color: Theme.of(context).focusColor,
            expanded: true,
          ),

          if (value != null)
            IconButton(
              onPressed: () => callback(null),
              icon: Icon(Icons.close),
            ),
        ],
      ),
    );
  }
}
