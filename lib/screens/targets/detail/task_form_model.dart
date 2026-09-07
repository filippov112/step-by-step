import 'dart:async';

import 'package:chaos_control/models/task.dart';
import 'package:chaos_control/models/target.dart';
import 'package:chaos_control/services/datetool.dart';
import 'package:chaos_control/services/target_calculator.dart';
import 'package:chartify/chartify.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class TaskFormModel extends ChangeNotifier {
  final _taskRepo = TaskRepository();

  String? desc;
  int success = 0;
  DateTime date = DateTool.today();
  int minSF = 0, maxSF = 0, sf = 0;

  Task? task;
  bool isEditing = false;

  void initTask(Task? value, Target target, int tasksCount) {
    isEditing = value != null;
    minSF = TargetCalculator.getFailurePrice(target.difficulty, tasksCount, target.status);
    maxSF = TargetCalculator.getSuccesPrice(target.difficulty, tasksCount, target.status);

    desc = value?.description ?? '';
    success = value?.success ?? 0;
    date = value?.date ?? DateTool.today();
    task = value ?? Task.create(targetId: target.id, date: date);
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

    task?.description = desc ?? '';
    task?.success = success;
    task?.date = date;
    task?.spiritFragments = sf;

    if (task == null) return;

    if (isEditing) {
      await _taskRepo.update(task!);
    } else {
      await _taskRepo.insert(task!);
    }
  }

  @override
  void dispose() {
    _initController.close();
    super.dispose();
  }
}