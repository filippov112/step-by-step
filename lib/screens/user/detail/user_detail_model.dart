import 'dart:math';

import 'package:flutter/material.dart';
import 'package:life_game/models/user.dart';
import 'package:life_game/services/analytics_repository.dart';
import 'package:snap_chart/snap_chart.dart';

enum StatPeriod { threeMonth, oneMonth, oneWeek }

class UserDetailModel extends ChangeNotifier {
  final _userRepo = UserRepository();
  final _analRepo = AnalyticsRepository();

  final Map<DateTime,int> tasks = {}, experiences = {}, times = {};
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
      case StatPeriod.threeMonth: return 90;
      case StatPeriod.oneMonth: return 30;
      case StatPeriod.oneWeek: return 7;
    }
  }

  // Загрузить статистику
  Future loadStatistics() async {
    if (user == null) return;
    var now = DateTime.now();
    lastDay = DateTime(now.year, now.month, now.day, 3);
    firstDay = lastDay.subtract(Duration(days:subtractDays()));
    
    List<DailyAggregate> daysData = await _analRepo.getDailyAggregates(
      startDate: getDaysFromDate(firstDay), 
      endDate: getDaysFromDate(lastDay)
    );

    tasks.clear();
    experiences.clear();
    times.clear();
    progressExpData.clear();
    progressTimeData.clear();
    deltaExp = 0;
    deltaTime = 0;

    for (var day in daysData) {
      tasks[day.dateTime] = day.taskCount;
      experiences[day.dateTime] = day.totalExperience;
      times[day.dateTime] = day.totalTime;
      maxExp = max(maxExp, day.totalExperience);
      maxTime = max(maxTime, day.totalTime);
      maxTasksCount = max(maxTasksCount, day.taskCount);
      deltaExp += day.totalExperience;
      deltaTime += day.totalTime;
    }
    if (daysData.isEmpty) {
      notifyListeners();
      return;
    }

    var dayIndex = lastDay;
    var summaExp = user!.experience;
    var summaTime = user!.time;
    while (dayIndex.millisecondsSinceEpoch >= firstDay.millisecondsSinceEpoch) {
      progressTimeData.add(SnapSpot(dayIndex.millisecondsSinceEpoch.toDouble(), summaTime.toDouble()));
      if (times.keys.contains(dayIndex)) {
        summaTime -= times[dayIndex] ?? 0;
      }
      progressExpData.add(SnapSpot(dayIndex.millisecondsSinceEpoch.toDouble(), summaExp.toDouble()));
      if (experiences.keys.contains(dayIndex)) {
        summaExp -= experiences[dayIndex] ?? 0;
      }
      dayIndex = dayIndex.subtract(Duration(days: 1));
    }

    notifyListeners();
  }

  DateTime getDateFromDays(int days) {
    return DateTime.fromMillisecondsSinceEpoch(days * 24 * 60 * 60 * 1000);
  }

  int getDaysFromDate(DateTime dtime) {
    return dtime.millisecondsSinceEpoch ~/ (24 * 60 * 60 * 1000);
  }
}