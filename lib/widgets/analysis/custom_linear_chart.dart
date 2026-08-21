import 'package:flutter/material.dart';
import 'package:snap_chart/snap_chart.dart';

// Линейный график
class CustomLinearChart extends StatelessWidget {
  const CustomLinearChart({
    super.key,
    required this.sortedData, // Данные для графиков
    required this.minV, // Начало периода
    required this.maxV, // Окончание периода
    this.colors, // Цвета графиков
    this.height = 100, // Высота графика
    this.width, // Ширина графика
    this.curved = false, // Сглаживание
    this.filled = true, // Заливка области под графиком
    this.lineWidth = 1, // Толщина линии
    this.fillOpacity = 0.7, // Прозрачность заливки
  });

  final double minV;
  final double maxV;
  final List<List<SnapSpot>> sortedData;
  final List<Color>? colors;
  final double? height;
  final double? width;
  final bool curved;
  final bool filled;
  final double lineWidth;
  final double fillOpacity;

  @override
  Widget build(BuildContext context) {

    return SizedBox(
      height: height, 
      width: width,
      child: SnapLineChart(
        multiLines: sortedData,
        curved: curved,
        filled: filled,
        showTooltip: false,
        style: SnapChartStyle(
          showGrid: false,
          showLabels: false,
          showBorder: false
        ),
        lineWidth: lineWidth,
        lineColors: colors,
        fillOpacity: fillOpacity,
        minX: minV,
        maxX: maxV,
      ),
    );
  }
  
}