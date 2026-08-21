import 'dart:math';
import 'package:flutter/material.dart';
import 'package:life_game/services/analytics_repository.dart';
import 'package:life_game/tools/format_date.dart';
import 'package:life_game/widgets/analysis/custom_activity_table.dart';
import 'package:life_game/widgets/common/custom_card_block.dart';
import 'package:life_game/widgets/common/custom_text.dart';


// Виджет отображения активности пользователя
class UserActivity extends StatefulWidget {
  final List<DailyAggregate> data;
  const UserActivity({super.key,  
    required this.data,
  });

  @override
  State<UserActivity> createState() => _UserActivityState();
}

enum UserActivityType { time, exp, tasks }

class _UserActivityState extends State<UserActivity> {
 
  UserActivityType selectedType = UserActivityType.tasks;
  

  @override
  Widget build(BuildContext context) {


    final Map<DateTime,int> tasks = {}, experiences = {}, times = {};
    int maxExp = 0;
    int maxTime = 0;
    int maxTasksCount = 0;
    DateTime? firstDay, lastDay;

    
    for (var day in widget.data) {
      tasks[day.dateTime] = day.taskCount;
      experiences[day.dateTime] = day.totalExperience;
      times[day.dateTime] = day.totalTime;
      maxExp = max(maxExp, day.totalExperience);
      maxTime = max(maxTime, day.totalTime);
      maxTasksCount = max(maxTasksCount, day.taskCount);
    }
    if (widget.data.isNotEmpty) {
      firstDay = DateTime.fromMillisecondsSinceEpoch(tasks.keys.map((e) => e.millisecondsSinceEpoch).toList().reduce(min));
      lastDay = DateTime.fromMillisecondsSinceEpoch(tasks.keys.map((e) => e.millisecondsSinceEpoch).toList().reduce(max));
    }
    Map<DateTime,int> _getData() {
      switch (selectedType) {
        case UserActivityType.time: return times;
        case UserActivityType.exp: return experiences;
        default: return tasks;
      }
    }

    int _getMaxValue() {
      switch (selectedType) {
        case UserActivityType.time: return maxTime;
        case UserActivityType.exp: return maxExp;
        default: return maxTasksCount;
      }
    }
      
    return CustomCardBlock(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Заголовок
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [

              // Иконка
              Icon(Icons.speed, size: 32),
              const SizedBox(width: 8),
              
              // Название блока
              CustomText(
                'Активность',
                size: 16,
                color: Theme.of(context).colorScheme.onPrimary,
                expanded: true,
                weight: FontWeight(500),
              ),

              // Тип данных
              Padding(
                padding: EdgeInsetsGeometry.only(left: 8),
                child: IconButton(
                  color: selectedType == UserActivityType.tasks ? Theme.of(context).focusColor : Theme.of(context).dividerColor,
                  onPressed: () => setState(() => selectedType = UserActivityType.tasks), icon: Icon(Icons.task_alt_outlined)),
              ),
              Padding(
                padding: EdgeInsetsGeometry.only(left: 8),
                child: IconButton(
                  color: selectedType == UserActivityType.exp ? Theme.of(context).focusColor : Theme.of(context).dividerColor,
                  onPressed: () => setState(() => selectedType = UserActivityType.exp), icon: Icon(Icons.wb_incandescent)),
              ),
              Padding(
                padding: EdgeInsetsGeometry.only(left: 8),
                child: IconButton(
                  color: selectedType == UserActivityType.time ? Theme.of(context).focusColor : Theme.of(context).dividerColor,
                  onPressed: () => setState(() => selectedType = UserActivityType.time), icon: Icon(Icons.schedule_outlined)),
              ),
            ],
          ),

          
          const SizedBox(height: 8),
          
          if (firstDay != null && lastDay != null)
          SizedBox(
            height: 150,
            child: CustomActivityTable(
              activities: _getData(),
              maxValue: _getMaxValue(),
              startDate: firstDay,
              endDate: lastDay,
              cellSpacing: 3,
              showMonthLabels: true,
              showWeekLabels: true,
              onCellTap: (date) {
                var day = widget.data.firstWhere((d) => d.dateTime == date);
                _showActivityDetails(context, date, 
                  day.totalExperience, 
                  day.totalTime, 
                  day.taskCount
                );
              },
            )
          ),
          
        ],
      )
    );
  }

  

  void _showActivityDetails(BuildContext context, DateTime date, int exp, int time, int count) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(formatDate(date)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
          Text('Трудозатраты: $time'),
          Text('Получено опыта: $exp'),
          Text('Выполнено задач: $count'),
        ],),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Закрыть'),
          ),
        ],
      ),
    );
  }
}
