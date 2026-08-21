import 'package:flutter/material.dart';
import 'package:life_game/models/user.dart';
import 'package:life_game/services/analytics_repository.dart';

class UserDetailModel extends ChangeNotifier {
  final _userRepo = UserRepository();
  final _analRepo = AnalyticsRepository();

  User? user;
  List<DailyAggregate> daysData = [];

  Future loadUser() async {
    user = await _userRepo.get();
    daysData = await _analRepo.getDailyAggregates(startDate: 19726, endDate: 19782);
    notifyListeners();
  }

  DateTime getDateFromDays(int days) {
    return DateTime.fromMillisecondsSinceEpoch(days * 24 * 60 * 60 * 1000);
  }
}