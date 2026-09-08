import 'package:chartify/chartify.dart';
import 'package:flutter/material.dart';

class CustomRadarChart extends StatelessWidget {
  final String seriesName;
  final double? height;
  final Color? color;
  final List<String> labels;
  final List<double> values;
  
  const CustomRadarChart({
    super.key,
    required this.seriesName,
    required this.labels,
    required this.values,
    this.color,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height ?? 300,
      child: RadarChart(
        data: RadarChartData(
          axes: labels,
          series: [
            RadarSeries(
              name: seriesName,
              values: values,
              color: color ?? Theme.of(context).focusColor,
            ),
          ],
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
