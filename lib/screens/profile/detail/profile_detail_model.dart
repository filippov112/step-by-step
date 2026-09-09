import 'dart:math';
import 'package:chaos_control/models/enums/characteristics.dart';
import 'package:flutter/material.dart';
import 'package:chaos_control/models/profile.dart';
import 'package:chaos_control/services/analytics/analytics_repository.dart';
import 'package:chaos_control/services/analytics/dto_activity.dart';
import 'package:chaos_control/services/datetool.dart';
import 'package:snap_chart/snap_chart.dart';

enum StatPeriod { threeMonth, oneMonth, oneWeek }

class ProfileDetailModel extends ChangeNotifier {
  final _userRepo = ProfileRepository();
  final _analRepo = AnalyticsRepository();

  // --- SF ---
  Map<DateTime, int> spiritFragments = {};
  List<SnapSpot> progressSFData = [];
  int deltaSF = 0;
  int maxSF = 0;
  DateTime firstDay = DateTime(0), lastDay = DateTime(0);
  StatPeriod selectedPeriod = StatPeriod.oneMonth;


  // --- Chars ---
  Map<Characteristic,int>? chars;
  
  
  Profile? user;

  

  // Инициализация страницы
  Future loadData() async {
    await _loadUser();
    await _loadSFData();
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

  // Загрузить статистику по фрагментам духа
  Future _loadSFData() async {
    if (user == null) return;
    var now = DateTime.now();
    lastDay = DateTime(now.year, now.month, now.day, 3);
    firstDay = lastDay.subtract(Duration(days: subtractDays()));

    List<DtoActivity> daysData = await _analRepo.getDailyExpTime(
      startDate: DateTool.datetimeToDays(firstDay),
      endDate: DateTool.datetimeToDays(lastDay),
    );

    spiritFragments = {};
    progressSFData = [];
    deltaSF = 0;

    for (var day in daysData) {
      if (day.dateTime == null) continue;
      spiritFragments[day.dateTime!] = day.totalExperience;
      maxSF = max(maxSF, day.totalExperience);
      deltaSF += day.totalExperience;
    }

    int dayIndex = DateTool.datetimeToDays(lastDay) ?? 0;
    int firstDayIndex = DateTool.datetimeToDays(firstDay) ?? 0;
    var summaEff = user!.spiritFragments;
    while (dayIndex >= firstDayIndex) {
      final dayDateTime = DateTool.joinDateTime(date: dayIndex);
      progressSFData.add(
        SnapSpot(
          dayIndex.toDouble(),
          summaEff.toDouble(),
        ),
      );
      if (spiritFragments.keys.contains(dayDateTime)) {
        summaEff -= spiritFragments[dayDateTime] ?? 0;
      }
      dayIndex--;
    }
    notifyListeners();
  }
}
