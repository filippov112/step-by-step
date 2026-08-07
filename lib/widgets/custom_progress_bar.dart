// ---- Прогресс-бар с иконкой и числом ----
import 'package:flutter/material.dart';

class CustomProgressBar extends StatelessWidget {
  
  const CustomProgressBar({super.key,   
    required this.label,
    required this.value,
    required this.maxValue,
    required this.icon,
    this.showAsPercent = true
  });

  final String label;
  final double value;
  final double maxValue;
  final IconData icon;
  final bool showAsPercent;

    @override
  Widget build(BuildContext context) {
    final percent = maxValue > 0 ? (value / maxValue).clamp(0.0, 1.0) : 0.0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, size: 18),
            const SizedBox(width: 8),
            Text(
              label,
              style: const TextStyle(fontSize: 14),
            ),
            const Spacer(),
            Text(
              showAsPercent
                  ? '${(percent * 100).toInt()}%'
                  : '${value.toInt()} / ${maxValue.toInt()}',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: LinearProgressIndicator(
            value: percent,
            minHeight: 10,
          ),
        ),
      ],
    );

  }
}
