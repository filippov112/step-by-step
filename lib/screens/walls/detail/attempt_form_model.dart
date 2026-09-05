import 'dart:async';

import 'package:chaos_control/models/attempt.dart';
import 'package:chaos_control/models/wall.dart';
import 'package:chaos_control/services/datetool.dart';
import 'package:chaos_control/services/wall_calculator.dart';
import 'package:chartify/chartify.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class AttemptFormModel extends ChangeNotifier {
  final _attemptRepo = AttemptRepository();

  String? desc;
  int success = 0;
  DateTime date = DateTool.today();
  int minSF = 0, maxSF = 0, sf = 0;

  Attempt? attempt;
  bool isEditing = false;

  void initAttempt(Attempt? value, Wall wall, int attemptsCount) {
    isEditing = value != null;
    minSF = WallCalculator.getFailurePrice(wall.difficulty, attemptsCount, wall.status);
    maxSF = WallCalculator.getSuccesPrice(wall.difficulty, attemptsCount, wall.status);

    desc = value?.description ?? '';
    success = value?.success ?? 0;
    date = value?.date ?? DateTool.today();
    attempt = value ?? Attempt.create(wallId: wall.id, date: date);
    _recalcSF();

    notifyListeners();
    _initController.add(true);
  }
  void _recalcSF() {
    sf = lerpDouble(minSF.toDouble(), maxSF.toDouble(), success.toDouble() / 100).toInt();
  }

  final StreamController<bool> _initController = StreamController<bool>.broadcast();
  Stream<bool> get initStream => _initController.stream.asBroadcastStream();

  void setDesc(String? value) {
    desc = value;
    notifyListeners();
  }
  void setSuccess(int value) {
    success = value;
    _recalcSF();
    notifyListeners();
  }
  void setDate(DateTime value) {
    date = value;
    notifyListeners();
  }

  Future save() async {

    attempt?.description = desc ?? '';
    attempt?.success = success;
    attempt?.date = date;
    attempt?.spiritFragments = sf;

    if (attempt == null) return;

    if (isEditing) {
      await _attemptRepo.update(attempt!);
    } else {
      await _attemptRepo.insert(attempt!);
    }
  }

  @override
  void dispose() {
    _initController.close();
    super.dispose();
  }
}