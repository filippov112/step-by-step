import 'dart:async';
import 'package:chaos_control/models/enums/characteristics.dart';
import 'package:chaos_control/models/enums/difficulty_lvl.dart';
import 'package:chaos_control/models/barrier.dart';
import 'package:chaos_control/services/datetool.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class BarrierFormModel extends ChangeNotifier {
  final _barRepo = BarrierRepository();

  String desc = '';
  String group = '';
  int diffIndex = 0;
  DateTime date = DateTool.today();
  Characteristic characteristic = Characteristic.perseverance;

  int sf = 0;
  Barrier? barrier;
  bool isEditing = false;

  void init(Barrier? bar) {
    isEditing = bar != null;

    diffIndex = bar?.difficulty.index ?? 0;
    desc = bar?.description ?? '';
    group = bar?.group ?? '';
    characteristic = bar?.char ?? Characteristic.perseverance;
    date = bar?.date ?? DateTool.today();

    barrier = bar ?? Barrier.create(date: date);
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

  void setDesc(String value) {
    desc = value;
    notifyListeners();
  }
  void setGroup(String value) {
    group = value;
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
        barrier?.control = sf;
      case Characteristic.perseverance:
        barrier?.perseverance = sf;
      case Characteristic.courage:
        barrier?.courage = sf;
      case Characteristic.durability:
        barrier?.durability = sf;
      case Characteristic.creativity:
        barrier?.creativity = sf;
    }
  }

  Future save() async {
    if (barrier == null) return;

    barrier?.description = desc;
    barrier?.group = group;
    barrier?.char = characteristic;
    barrier?.date = date;
    barrier?.difficulty = DifficultyLvl.values[diffIndex];

    _recalcChars();

    if (isEditing) {
      await _barRepo.update(barrier!);
    } else {
      await _barRepo.insert(barrier!);
      init(null);
    }
  }

  @override
  void dispose() {
    _initController.close();
    super.dispose();
  }
}
