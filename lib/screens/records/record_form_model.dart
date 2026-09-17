import 'dart:async';
import 'package:chaos_control/models/enums/characteristics.dart';
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
  int hours = 0;
  bool challenge = false;
  DateTime date = DateTool.today();
  List<int> charTypes = [];

  int sf = 0;
  ChronicleRecord? record;
  bool isEditing = false;

  void init(ChronicleRecord? rec, String gr, {bool softClear = false}) {
    isEditing = rec != null;

    if (!softClear) {
      hours = rec?.hours ?? 0;
      challenge = rec?.challenge ?? false;
      desc = rec?.description ?? '';
      group = gr;
      charTypes = rec?.charTypes ?? [];
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
    hours = 0;
    challenge = false;
    desc = '';
    group = '';
    charTypes = [];
    date = DateTool.today();
    record = null;
    sf = 0;
  }

  void _recalcSF() {
    sf = challenge ? 0 : hours;
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
  void setHours(int value) {
    hours = value;
    _recalcSF();
    notifyListeners();
  }
  void changeChallengeStatus() {
    challenge = !challenge;
    _recalcSF();
    notifyListeners();
  }
  void setCharTypes(List<int> value) {
    charTypes = value;
    _recalcSF();
    notifyListeners();
  }
  void setDate(DateTime value) {
    date = value;
    notifyListeners();
  }

  void _recalcChars() {
    record?.clearChars();
    for (var type in charTypes) {
      Characteristic charType = Characteristic.values[type];
      switch (charType) {
        case Characteristic.happiness:
          record?.happiness = sf;
        case Characteristic.diligence:
          record?.diligence = sf;
        case Characteristic.intellection:
          record?.intellection = sf;
        case Characteristic.durability:
          record?.durability = sf;
        case Characteristic.potencial:
          record?.potencial = sf;
      }
    }
  }

  Future save() async {
    if (record == null) return;

    record?.description = desc;
    record?.group = group;
    record?.charTypes = charTypes;
    record?.date = date;
    record?.hours = hours;
    record?.challenge = challenge;
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
