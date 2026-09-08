import 'dart:async';

import 'package:chaos_control/models/task.dart';
import 'package:chaos_control/models/target.dart';
import 'package:chaos_control/services/datetool.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class TaskFormModel extends ChangeNotifier {
  final _taskRepo = TaskRepository();

  String? desc;
  int time = 0;
  int diff = 0;
  DateTime date = DateTool.today();
  int sf = 0;

  Task? task;
  bool isEditing = false;

  void initTask(Task? value, Target target, int tasksCount) {
    isEditing = value != null;

    desc = value?.description ?? '';
    time = value?.time ?? 0;
    diff = value?.diff ?? 0;
    date = value?.date ?? DateTool.today();
    task = value ?? Task.create(targetId: target.id, date: date);
    _recalcSF();

    notifyListeners();
    _initController.add(true);
  }
  void _recalcSF() {
    sf = time * diff;
  }

  final StreamController<bool> _initController = StreamController<bool>.broadcast();
  Stream<bool> get initStream => _initController.stream.asBroadcastStream();

  void setDesc(String? value) {
    desc = value;
    notifyListeners();
  }
  void setTime(int value) {
    time = value;
    _recalcSF();
    notifyListeners();
  }
  void setDiff(int value) {
    diff = value;
    _recalcSF();
    notifyListeners();
  }
  void setDate(DateTime value) {
    date = value;
    notifyListeners();
  }

  Future save() async {

    task?.description = desc ?? '';
    task?.time = time;
    task?.diff = diff;
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