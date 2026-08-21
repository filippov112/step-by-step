import 'package:chartify/chartify.dart';
import 'package:flutter/material.dart';

class CustomRadarChart extends StatelessWidget {
  const CustomRadarChart({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 300, child: RadarChart(
        data: const RadarChartData(
          axes: ['Speed', 'Power', 'Defense', 'Range', 'Accuracy', 'Mobility'],
          series: [
            RadarSeries(
              name: 'Player A',
              values: [85, 70, 60, 90, 75, 80],
              color: Color(0xFF3B82F6),
            ),
            RadarSeries(
              name: 'Player B',
              values: [70, 85, 75, 65, 90, 70],
              color: Color(0xFFEF4444),
            ),
          ],
          tickCount: 5,
          gridType: RadarGridType.polygon, // or .circular
        ),
        animation: const ChartAnimation(
          duration: Duration(milliseconds: 1000),
          curve: Curves.easeOutCubic,
        ),
      )
    );
  }
}