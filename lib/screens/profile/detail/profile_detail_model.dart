import 'dart:math';
import 'package:chaos_control/models/enums/characteristics.dart';
import 'package:chaos_control/services/spirit_calculator.dart';
import 'package:flutter/material.dart';
import 'package:chaos_control/models/profile.dart';
import 'package:chaos_control/services/analytics/analytics_repository.dart';
import 'package:chaos_control/services/analytics/dto_activity.dart';
import 'package:chaos_control/services/datetool.dart';
import 'package:snap_chart/snap_chart.dart';

enum PeriodFilterType { year, threeMonth, oneMonth, oneWeek, oneDay }
extension StatPeriodExt on PeriodFilterType {
  String get displayName {
    switch (this) {
      case PeriodFilterType.year:
        return 'За год';
      case PeriodFilterType.threeMonth:
        return 'За квартал';
      case PeriodFilterType.oneMonth:
        return 'За месяц';
      case PeriodFilterType.oneWeek:
        return 'За неделю';
      case PeriodFilterType.oneDay:
        return 'За день';
    }
  }

  int get days {
     switch (this) {
      case PeriodFilterType.year:
        return 365;
      case PeriodFilterType.threeMonth:
        return 90;
      case PeriodFilterType.oneMonth:
        return 30;
      case PeriodFilterType.oneWeek:
        return 6;
      case PeriodFilterType.oneDay:
        return 0;
    }
  }
}

class ProfileDetailModel extends ChangeNotifier {
  late final SpiritCalculator calculator;
  final _userRepo = ProfileRepository();
  final _analRepo = AnalyticsRepository();
  Profile? user;
  Map<Characteristic,int>? chars;

  ProfileDetailModel(this.calculator);

  // Наборы данных за выбранный период
  Map<DateTime, DtoActivity> activityData = {};
  List<SnapSpot> graphData = [];
  Map<Characteristic,int>? deltaChars;

  int deltaSF = 0;
  int maxSF = 0;

  // Фильтр периода
  DateTime firstDay = DateTime(0), lastDay = DateTime(0);
  PeriodFilterType periodFilter = PeriodFilterType.oneMonth;

  // Сброс фильтров
  bool get hasActiveFilters {
    return groupFilter.isNotEmpty || periodFilter != PeriodFilterType.oneMonth;
  }
  Future clearAllFilters() async {
    groupFilter = '';
    periodFilter = PeriodFilterType.oneMonth;
    await _loadSFData();
    notifyListeners();
  }

  // Фильтр группы
  String groupFilter = '';
  Future setGroupFilter(String value) async {
    groupFilter = value;
    await _loadSFData();
    notifyListeners();
  }
  

  // Инициализация страницы
  Future loadData() async {
    await _loadUser();
    await _loadSFData();
    notifyListeners();
  }

  // Перерасчет характеристик
  Future recalcStats() async {
    await calculator.recalcUserChars();
    await loadData();
  }

  // Переключить фильтр периода
  Future setPeriodFilter(PeriodFilterType period) async {
    periodFilter = period;
    await _loadSFData();
    notifyListeners();
  }

  // Загрузить данные пользователя
  Future _loadUser() async {
    user = await _userRepo.get();
    chars = user?.chars;
  }

  // Загрузить статистику по фрагментам духа
  Future _loadSFData() async {
    if (user == null) return;

    lastDay = DateTool.today();
    firstDay = lastDay.subtract(Duration(days: periodFilter.days));
    int dayIndex = DateTool.datetimeToDays(lastDay) ?? 0;
    int firstDayIndex = DateTool.datetimeToDays(firstDay) ?? 0;

    List<DtoActivity> daysData = await _analRepo.getDailyExpTime(
      startDate: DateTool.datetimeToDays(firstDay),
      endDate: DateTool.datetimeToDays(lastDay),
      pattern: groupFilter
    );

    activityData = {};
    graphData = [];
    deltaChars = {
      Characteristic.happiness: 0,
      Characteristic.diligence: 0,
      Characteristic.intellection: 0,
      Characteristic.durability: 0,
      Characteristic.potencial: 0,
    };
    deltaSF = 0;
    maxSF = 0;

    // Activity & Chars & Stats
    for (var day in daysData) {
      if (day.dateTime == null) continue;
      activityData[day.dateTime!] = day;
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
        summaEff -= activityData[dayDateTime]?.totalExperience ?? 0;
      }
      dayIndex--;
    }
  }
}
