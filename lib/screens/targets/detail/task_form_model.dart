import 'dart:async';

import 'package:chaos_control/models/enums/characteristics.dart';
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
  Target? target;
  Map<Characteristics,int>? currentChars;

  Task? task;
  bool isEditing = false;

  void initTask(Task? tsk, Target target, int tasksCount) {
    isEditing = tsk != null;

    this.target = target;
    currentChars = tsk?.chars ?? target.chars;
    desc = tsk?.description ?? '';
    time = tsk?.time ?? 0;
    diff = tsk?.diff ?? 0;
    date = tsk?.date ?? DateTool.today();
    task = tsk ?? Task.create(targetId: target.id, date: date);
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
  void setChars(Map<Characteristics,int> value) {
    currentChars = value;
    notifyListeners();
  }

  Future save() async {

    task?.description = desc ?? '';
    task?.time = time;
    task?.diff = diff;
    task?.date = date;
    
    task?.control = (sf.toDouble() * (currentChars?[Characteristics.control] ?? 0) / 100).toInt();
    task?.perseverance = (sf.toDouble() * (currentChars?[Characteristics.perseverance] ?? 0) / 100).toInt();
    task?.courage = (sf.toDouble() * (currentChars?[Characteristics.courage] ?? 0) / 100).toInt();
    task?.durability = (sf.toDouble() * (currentChars?[Characteristics.durability] ?? 0) / 100).toInt();
    task?.creativity = (sf.toDouble() * (currentChars?[Characteristics.creativity] ?? 0) / 100).toInt();

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