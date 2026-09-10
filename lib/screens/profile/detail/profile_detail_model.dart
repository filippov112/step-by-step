import 'dart:math';
import 'package:chaos_control/models/enums/characteristics.dart';
import 'package:chaos_control/services/spirit_calculator.dart';
import 'package:flutter/material.dart';
import 'package:chaos_control/models/profile.dart';
import 'package:chaos_control/services/analytics/analytics_repository.dart';
import 'package:chaos_control/services/analytics/dto_activity.dart';
import 'package:chaos_control/services/datetool.dart';
import 'package:snap_chart/snap_chart.dart';

enum StatPeriod { threeMonth, oneMonth, oneWeek, oneDay }

class ProfileDetailModel extends ChangeNotifier {
  final _userRepo = ProfileRepository();
  final _analRepo = AnalyticsRepository();
  Profile? user;
  Map<Characteristic,int>? chars;

  // Params
  DateTime firstDay = DateTime(0), lastDay = DateTime(0);
  StatPeriod selectedPeriod = StatPeriod.oneMonth;

  // Наборы данных за выбранный период
  Map<DateTime, int> activityData = {};
  List<SnapSpot> graphData = [];
  Map<Characteristic,int>? deltaChars;

  int deltaSF = 0;
  int maxSF = 0;

  bool charTableMode = false;
  

  // Инициализация страницы
  Future loadData() async {
    await _loadUser();
    await _loadSFData();
    notifyListeners();
  }

  // Перерасчет характеристик
  Future recalcStats() async {
    await SpiritCalculator.recalcUserChars();
    await loadData();
  }

  // Переключить фильтр периода
  Future setPeriodFilter(StatPeriod period) async {
    selectedPeriod = period;
    await _loadSFData();
    notifyListeners();
  }

  // Загрузить данные пользователя
  Future _loadUser() async {
    user = await _userRepo.get();
    chars = user?.chars;
  }

  int _subtractDays() {
    switch (selectedPeriod) {
      case StatPeriod.threeMonth:
        return 90;
      case StatPeriod.oneMonth:
        return 30;
      case StatPeriod.oneWeek:
        return 6;
      case StatPeriod.oneDay:
        return 0;
    }
  }

  void setChartTableMode(bool bool) {
    charTableMode = bool;
    notifyListeners();
  }

  // Загрузить статистику по фрагментам духа
  Future _loadSFData() async {
    if (user == null) return;

    lastDay = DateTool.today();
    firstDay = lastDay.subtract(Duration(days: _subtractDays()));
    int dayIndex = DateTool.datetimeToDays(lastDay) ?? 0;
    int firstDayIndex = DateTool.datetimeToDays(firstDay) ?? 0;

    List<DtoActivity> daysData = await _analRepo.getDailyExpTime(
      startDate: DateTool.datetimeToDays(firstDay),
      endDate: DateTool.datetimeToDays(lastDay),
    );

    activityData = {};
    graphData = [];
    deltaChars = {
      Characteristic.control: 0,
      Characteristic.perseverance: 0,
      Characteristic.courage: 0,
      Characteristic.durability: 0,
      Characteristic.creativity: 0,
    };
    deltaSF = 0;
    maxSF = 0;

    // Activity & Chars & Stats
    for (var day in daysData) {
      if (day.dateTime == null) continue;
      activityData[day.dateTime!] = day.totalExperience;
      for(var ch in Characteristic.values) {
        deltaChars![ch] = (deltaChars![ch] ?? 0) + day.getChar(ch);
      }
      maxSF = max(maxSF, day.totalExperience);
      deltaSF += day.totalExperience;
    }

    // Graph
    var summaEff = user!.spiritFragments;
    while (dayIndex >= firstDayIndex) {
      final dayDateTime = DateTool.joinDateTime(date: dayIndex);
      graphData.add(
        SnapSpot(
          dayIndex.toDouble(),
          summaEff.toDouble(),
        ),
      );
      if (activityData.keys.contains(dayDateTime)) {
        summaEff -= activityData[dayDateTime] ?? 0;
      }
      dayIndex--;
    }
  }
}
