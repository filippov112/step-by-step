import 'package:chaos_control/widgets/common/custom_card_block.dart';
import 'package:chaos_control/widgets/common/custom_text.dart';
import 'package:flutter/material.dart';

// Поле чекбокса
class CustomCheckbox extends StatelessWidget {
  final bool initValue;
  final Function(bool) setValue;
  final String label;
  final Color? backColor;
  const CustomCheckbox({
    super.key,
    required this.initValue,
    required this.setValue,
    required this.label,
    this.backColor,
  });

  @override
  Widget build(BuildContext context) {
    return CustomCardBlock(
      backColor: backColor,
      padding: const EdgeInsets.all(0),
      child: InkWell(
        borderRadius: const BorderRadius.all(Radius.circular(12)),
        onTap: () => setValue(!initValue),
        child: Padding(
          padding: const EdgeInsetsGeometry.all(6),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            children: [
              Checkbox(
                value: initValue,
                onChanged: (v) => setValue(v ?? false),
              ),
              CustomText(label, expanded: true),
            ],
          ),
        ),
      ),
    );
  }
}
