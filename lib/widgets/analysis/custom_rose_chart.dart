import 'package:chartify/chartify.dart';
import 'package:flutter/material.dart';

class CustomRoseChart extends StatelessWidget {
  const CustomRoseChart({super.key});

  @override
  Widget build(BuildContext context) {
    return 
      SizedBox(height: 300, child:
        RoseChart(
          interactions: ChartInteractions.none(),
          animation: null,
          tooltip: TooltipConfig(
            showArrow: false
          ),
          data: const RoseChartData(
            showValues: true,
            segments: [
              RoseSegment(label: 'N', value: 12, color: Color(0xFF6366F1)),
              RoseSegment(label: 'NE', value: 8, color: Color(0xFF8B5CF6)),
              RoseSegment(label: 'E', value: 15, color: Color(0xFFA855F7)),
              RoseSegment(label: 'SE', value: 22, color: Color(0xFFC084FC)),
              RoseSegment(label: 'S', value: 18, color: Color(0xFFD8B4FE)),
              RoseSegment(label: 'SW', value: 10, color: Color(0xFFE9D5FF)),
              RoseSegment(label: 'W', value: 25, color: Color(0xFFF3E8FF)),
              RoseSegment(label: 'NW', value: 14, color: Color(0xFFEDE9FE)),
            ],
            innerRadius: 10,
            gap: 0,
            showLabels: true,
            startAngle: -90,
          ),
        )
      );
  }
}