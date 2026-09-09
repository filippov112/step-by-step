import 'dart:async';
import 'package:chaos_control/models/enums/characteristics.dart';
import 'package:chaos_control/models/enums/difficulty_lvl.dart';
import 'package:chaos_control/models/barrier.dart';
import 'package:chaos_control/models/target.dart';
import 'package:chaos_control/services/datetool.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class TaskFormModel extends ChangeNotifier {
  final _taskRepo = TaskRepository();

  String? desc;
  int diffIndex = 0;
  DateTime date = DateTool.today();
  Characteristic characteristic = Characteristic.perseverance;

  int sf = 0;
  Target? target;
  Barrier? task;
  bool isEditing = false;

  void initTask(Barrier? tsk, Target target, int tasksCount) {
    isEditing = tsk != null;

    this.target = target;

    diffIndex = tsk?.difficulty.index ?? 0;
    desc = tsk?.description ?? '';
    characteristic = tsk?.char ?? Characteristic.perseverance;
    date = tsk?.date ?? DateTool.today();

    task = tsk ?? Barrier.create(targetId: target.id, date: date);
    _recalcSF();

    notifyListeners();
    _initController.add(true);
  }

  void _recalcSF() {
    sf = DifficultyLvl.values[diffIndex].value;
  }

  final StreamController<bool> _initController =
      StreamController<bool>.broadcast();
  Stream<bool> get initStream => _initController.stream.asBroadcastStream();

  void setDesc(String? value) {
    desc = value;
    notifyListeners();
  }

  void setDiff(int value) {
    diffIndex = value;
    _recalcSF();
    notifyListeners();
  }

  void setChar(Characteristic value) {
    characteristic = value;
    _recalcSF();
    notifyListeners();
  }

  void setDate(DateTime value) {
    date = value;
    notifyListeners();
  }

  void _recalcChars() {
    switch (characteristic) {
      case Characteristic.control:
        task?.control = sf;
      case Characteristic.perseverance:
        task?.perseverance = sf;
      case Characteristic.courage:
        task?.perseverance = sf;
      case Characteristic.durability:
        task?.perseverance = sf;
      case Characteristic.creativity:
        task?.perseverance = sf;
    }
  }

  Future save() async {
    if (task == null) return;

    task?.description = desc ?? '';
    task?.char = characteristic;
    task?.date = date;
    task?.difficulty = DifficultyLvl.values[diffIndex];

    _recalcChars();

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
