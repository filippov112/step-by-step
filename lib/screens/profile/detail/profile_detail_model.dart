import 'dart:math';
import 'package:flutter/material.dart';
import 'package:chaos_control/models/profile.dart';
import 'package:chaos_control/services/analytics/analytics_repository.dart';
import 'package:chaos_control/services/analytics/dto_exp_time.dart';
import 'package:chaos_control/tools/datetime.dart';
import 'package:snap_chart/snap_chart.dart';

enum StatPeriod { threeMonth, oneMonth, oneWeek }

class ProfileDetailModel extends ChangeNotifier {
  final _userRepo = ProfileRepository();
  final _analRepo = AnalyticsRepository();

  Map<DateTime, int> efforts = {};
  int maxEff = 0;
  DateTime firstDay = DateTime(0), lastDay = DateTime(0);
  Profile? user;
  List<SnapSpot> progressEffortData = [];
  int deltaEfforts = 0;

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

    efforts = {};
    progressEffortData = [];
    deltaEfforts = 0;

    for (var day in daysData) {
      if (day.dateTime == null) continue;
      efforts[day.dateTime!] = day.totalExperience;
      maxEff = max(maxEff, day.totalExperience);
      deltaEfforts += day.totalExperience;
    }

    int dayIndex = DateTool.datetimeToDays(lastDay) ?? 0;
    int firstDayIndex = DateTool.datetimeToDays(firstDay) ?? 0;
    var summaEff = user!.efforts;
    while (dayIndex >= firstDayIndex) {
      final dayDateTime = DateTool.joinDateTime(date: dayIndex);
      progressEffortData.add(
        SnapSpot(
          dayIndex.toDouble(),
          summaEff.toDouble(),
        ),
      );
      if (efforts.keys.contains(dayDateTime)) {
        summaEff -= efforts[dayDateTime] ?? 0;
      }
      dayIndex--;
    }
    notifyListeners();
  }
}
