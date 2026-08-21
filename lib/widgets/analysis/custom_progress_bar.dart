import 'package:flutter/material.dart';

// Прогресс бар с дополнительной шкалой прироста значения
class CustomProgressBar extends StatelessWidget {
  
  const CustomProgressBar({super.key,   
    required this.value, // Основное значение
    required this.maxValue, // Предельное значение
    this.deltaValue, // Значение прироста
    this.height = 20, // Толщина шкалы
    this.mainColor, // Основной цвет шкалы
    this.deltaColor = Colors.orange, // Цвет отрезка прироста
    this.backColor, // Цвет фона
    this.radius, // Радиус скругления краев
  });

  final double? deltaValue;
  final double value;
  final double maxValue;
  final double? height;
  final Color? mainColor;
  final Color? deltaColor;
  final Color? backColor;
  final BorderRadiusGeometry? radius;


  double getPercent(double val, double max) {
    return max > 0 ? (val / max).clamp(0.0, 1.0) : 0.0;
  }

    @override
  Widget build(BuildContext context) {
    
    return ClipRRect(
      borderRadius: radius ?? BorderRadius.circular(12),
      child: deltaValue == null ?

      LinearProgressIndicator(
        minHeight: height,
        value: getPercent(value, maxValue),
        color: mainColor ?? Theme.of(context).focusColor,
        backgroundColor: backColor ?? Theme.of(context).dividerColor,
      ) :
    
      Stack(children: [
        LinearProgressIndicator(
          minHeight: height,
          value: getPercent(value, maxValue),
          color: deltaColor,
          backgroundColor: backColor ?? Theme.of(context).dividerColor,
        ),
        LinearProgressIndicator(
          value: deltaValue! >= value ? 0 : getPercent(value - deltaValue!, maxValue),
          minHeight: height,
          color: mainColor ?? Theme.of(context).focusColor,
          backgroundColor: Colors.white.withAlpha(0),
        ),
      ],) 
    );

  }
}
