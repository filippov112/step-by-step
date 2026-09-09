import 'package:chartify/chartify.dart';
import 'package:flutter/material.dart';

class CustomRadarChart extends StatelessWidget {

  final double? height;
  final List<String> labels;
  final List<RadarSeries> values;
  final EdgeInsets? padding;
  
  const CustomRadarChart({
    super.key,
    required this.labels,
    required this.values,
    this.height,
    this.padding
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height ?? 300,
      child: RadarChart(
        padding: padding ?? const EdgeInsets.all(0),
        data: RadarChartData(
          axes: labels,
          series: values,
          tickCount: 5,
          gridType: RadarGridType.circular,
        ),
        animation: const ChartAnimation(
          duration: Duration(milliseconds: 1000),
          curve: Curves.easeOutCubic,
        ),
      ),
    );
  }
}
