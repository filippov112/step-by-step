import 'package:flutter/material.dart';
import 'package:life_game/tools/get_age_string.dart';
import 'package:life_game/widgets/common/custom_text.dart';
import 'package:snap_chart/snap_chart.dart';

// График накопления опыта / времени
class AccumChart extends StatelessWidget {
  const AccumChart({
    super.key,
    required this.oldData, // Значения за ранние периоды
    required this.newData, // Значения за текущий период
    required this.firstDayDelta, // Начало текущего периода
    required this.firstDay, // Начало периода наблюдений
    required this.lastDay, // Окончание периода наблюдений
  });

  final DateTime firstDay;
  final DateTime lastDay;
  final List<SnapSpot> oldData;
  final DateTime firstDayDelta;
  final List<SnapSpot> newData;

  @override
  Widget build(BuildContext context) {


    return Container(
      padding: EdgeInsets.fromLTRB(8,8,8,4),
      decoration: BoxDecoration(
        
        borderRadius: const BorderRadius.all(Radius.circular(16)),
        border: Border.all(color: Theme.of(context).dividerColor, width: 2)
      ),
      child: Stack(children: [
        SizedBox(
          height: 100, 
          child: SnapLineChart(
            multiLines: [
                    oldData,
                    newData
                  ],
            curved: false,
            filled: true,
            showTooltip: false,
            style: SnapChartStyle(
              showGrid: false,
              showLabels: false,
              showBorder: false
            ),
            lineWidth: 1,
            lineColors: [Theme.of(context).focusColor, Colors.orange],
            fillOpacity: 0.7,
            minX: firstDay.millisecondsSinceEpoch.toDouble(),
            maxX: lastDay.millisecondsSinceEpoch.toDouble(),
          ),
        ),

        Container(
          padding: const EdgeInsets.all(8),
          height: 100, 
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Row(
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  CustomText(
                    '${getDateIntervalString(firstDay, lastDay)} / ${getDateIntervalString(firstDayDelta, lastDay)}'
                    , align: TextAlign.end,
                  ),
              ],
            ),
            ],
          )
        ,)
        
        
            
          
        
      ],)
      
    );
  }
  
}