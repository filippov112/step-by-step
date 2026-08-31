import 'package:flutter/material.dart';
import 'package:chaos_control/widgets/common/custom_text.dart';

class WallDetailDescChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color? color;

  const WallDetailDescChip({
    super.key,
    required this.icon,
    required this.label,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color?.withValues(alpha: 0.15) ?? Theme.of(context).dividerColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: color),
          const SizedBox(width: 4),
          CustomText(label, size: 12, color: color),
        ],
      ),
    );
  }
}
