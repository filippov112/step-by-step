// ---- Прогресс-бар с иконкой и числом ----
import 'package:flutter/material.dart';

// Прогресс бар с иконками для статистики
class AccumBar extends StatelessWidget {
  
  const AccumBar({super.key,   
    required this.value,
    required this.maxValue,
    required this.deltaValue,
  });

  final double deltaValue;
  final double value;
  final double maxValue;


  double getPercent(double val, double max) {
    return max > 0 ? (val / max).clamp(0.0, 1.0) : 0.0;
  }

    @override
  Widget build(BuildContext context) {
    
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: Stack(children: [
        LinearProgressIndicator(
          minHeight: 20,
          value: getPercent(value, maxValue),
          color: Colors.orange,
        ),
        LinearProgressIndicator(
          value: deltaValue >= value ? 0 : getPercent(value - deltaValue, maxValue),
          minHeight: 20,
          color: Theme.of(context).focusColor,
          backgroundColor: Colors.white.withAlpha(0),
        ),
      ],) 
    );

  }
}
