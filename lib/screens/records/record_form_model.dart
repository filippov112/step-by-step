import 'dart:async';
import 'package:chaos_control/models/enums/characteristics.dart';
import 'package:chaos_control/models/enums/difficulty_lvl.dart';
import 'package:chaos_control/models/record.dart';
import 'package:chaos_control/services/datetool.dart';
import 'package:chaos_control/services/notifications/implementations/n_new_record.dart';
import 'package:chaos_control/services/notifications/notification_service.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class RecordFormModel extends ChangeNotifier {
  final _recRepo = RecordRepository();
  final ns = NotificationService();

  String desc = '';
  String group = '';
  int diffIndex = 0;
  DateTime date = DateTool.today();
  Characteristic characteristic = Characteristic.perseverance;

  int sf = 0;
  ChronicleRecord? record;
  bool isEditing = false;

  void init(ChronicleRecord? rec, String gr, {bool softClear = false}) {
    isEditing = rec != null;

    if (!softClear) {
      diffIndex = rec?.difficulty.index ?? 0;
      desc = rec?.description ?? '';
      group = gr;
      characteristic = rec?.char ?? Characteristic.perseverance;
      date = rec?.date ?? DateTool.today();
    }
  
    record = rec ?? ChronicleRecord.create(date: date);
    _recalcSF();

    _initController.add(true);
    notifyListeners();
  }
  void clearModel() {
    if (record == null) return;
    isEditing = false;
    diffIndex = 0;
    desc = '';
    group = '';
    characteristic = Characteristic.perseverance;
    date = DateTool.today();
    record = null;
    sf = 0;
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
        record?.control = sf;
      case Characteristic.perseverance:
        record?.perseverance = sf;
      case Characteristic.courage:
        record?.courage = sf;
      case Characteristic.durability:
        record?.durability = sf;
      case Characteristic.creativity:
        record?.creativity = sf;
    }
  }

  Future save() async {
    if (record == null) return;

    record?.description = desc;
    record?.group = group;
    record?.char = characteristic;
    record?.date = date;
    record?.difficulty = DifficultyLvl.values[diffIndex];
    record?.time = DateTime.now().millisecondsSinceEpoch;

    _recalcChars();

    if (isEditing) {
      await _recRepo.update(record!);
      ns.showNotification(NNewRecord()..isUpdate=true);
    } else {
      await _recRepo.insert(record!);
      ns.showNotification(NNewRecord());
      init(null, group, softClear: true);
    }
  }

  @override
  void dispose() {
    _initController.close();
    super.dispose();
  }
}
