import 'dart:math';
import 'package:flutter/material.dart';
import 'package:chaos_control/models/user.dart';
import 'package:chaos_control/services/analytics/analytics_repository.dart';
import 'package:chaos_control/services/analytics/dto_exp_time.dart';
import 'package:chaos_control/services/analytics/dto_tasks.dart';
import 'package:chaos_control/tools/datetime.dart';
import 'package:snap_chart/snap_chart.dart';

enum StatPeriod { threeMonth, oneMonth, oneWeek }

class UserDetailModel extends ChangeNotifier {
  final _userRepo = UserRepository();
  final _analRepo = AnalyticsRepository();

  Map<DateTime, int> tasks = {}, experiences = {}, times = {};
  int maxExp = 0;
  int maxTime = 0;
  int maxTasksCount = 0;
  DateTime firstDay = DateTime(0), lastDay = DateTime(0);
  User? user;
  List<SnapSpot> progressExpData = [], progressTimeData = [];
  int deltaExp = 0, deltaTime = 0;

  StatPeriod selectedPeriod = StatPeriod.oneMonth;

  // Инициализация страницы
  Future loadData() async {
    await loadUser();
    await loadStatistics();
  }

  // Переключить фильтр периода
  Future setPeriodFilter(StatPeriod period) async {
    selectedPeriod = period;
    await loadStatistics();
    notifyListeners();
  }

  // Загрузить данные пользователя
  Future loadUser() async {
    user = await _userRepo.get();
    notifyListeners();
  }

  int subtractDays() {
    switch (selectedPeriod) {
      case StatPeriod.threeMonth:
        return 90;
      case StatPeriod.oneMonth:
        return 30;
      case StatPeriod.oneWeek:
        return 7;
    }
  }

  // Загрузить статистику
  Future loadStatistics() async {
    if (user == null) return;
    var now = DateTime.now();
    lastDay = DateTime(now.year, now.month, now.day, 3);
    firstDay = lastDay.subtract(Duration(days: subtractDays()));

    List<DtoExpTime> daysData = await _analRepo.getDailyExpTime(
      startDate: DateTool.datetimeToDays(firstDay),
      endDate: DateTool.datetimeToDays(lastDay),
    );
    List<DtoTasks> daysDataTasks = await _analRepo.getDailyTasks(
      startDate: DateTool.datetimeToDays(firstDay),
      endDate: DateTool.datetimeToDays(lastDay),
    );

    tasks = {};
    experiences = {};
    times = {};
    progressExpData = [];
    progressTimeData = [];
    deltaExp = 0;
    deltaTime = 0;

    for (var day in daysDataTasks) {
      if (day.dateTime == null) continue;
      tasks[day.dateTime!] = day.countTasks;
      maxTasksCount = max(maxTasksCount, day.countTasks);
    }
    for (var day in daysData) {
      if (day.dateTime == null) continue;
      experiences[day.dateTime!] = day.totalExperience;
      times[day.dateTime!] = day.totalTime;
      maxExp = max(maxExp, day.totalExperience);
      maxTime = max(maxTime, day.totalTime);
      deltaExp += day.totalExperience;
      deltaTime += day.totalTime;
    }

    int dayIndex = DateTool.datetimeToDays(lastDay) ?? 0;
    int firstDayIndex = DateTool.datetimeToDays(firstDay) ?? 0;
    var summaExp = user!.experience;
    var summaTime = user!.time;
    while (dayIndex >= firstDayIndex) {
      progressTimeData.add(
        SnapSpot(
          dayIndex.toDouble(),
          summaTime.toDouble(),
        ),
      );
      final dayDateTime = DateTool.joinDateTime(date: dayIndex);
      if (times.keys.contains(dayDateTime)) {
        summaTime -= times[dayDateTime] ?? 0;
      }
      progressExpData.add(
        SnapSpot(
          dayIndex.toDouble(),
          summaExp.toDouble(),
        ),
      );
      if (experiences.keys.contains(dayDateTime)) {
        summaExp -= experiences[dayDateTime] ?? 0;
      }
      dayIndex--;
    }

    notifyListeners();
  }
}
