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
  bool challenge = false, favorite = false;
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
      favorite = rec?.favorite ?? false;
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
    favorite = false;
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
  void changeFavoriteStatus() {
    favorite = !favorite;
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

  void _recalcChars(ChronicleRecord rec) {
    rec.clearChars();
    for (var type in charTypes) {
      Characteristic charType = Characteristic.values[type];
      switch (charType) {
        case Characteristic.happiness:
          rec.happiness = sf;
        case Characteristic.diligence:
          rec.diligence = sf;
        case Characteristic.intellection:
          rec.intellection = sf;
        case Characteristic.durability:
          rec.durability = sf;
        case Characteristic.potencial:
          rec.potencial = sf;
      }
    }
  }

  // Изменить / Создать запись
  Future save() async {
    if (record == null) return;
    record = _fillRecord(record!);

    if (isEditing) {
      await _recRepo.update(record!);
      ns.showNotification(NNewRecord()..isUpdate=true);
    } else {
      await _recRepo.insert(record!);
      ns.showNotification(NNewRecord());
      init(null, group, softClear: true);
    }
  }

  // Копировать существующую запись
  Future copy() async {
    var newRecord = ChronicleRecord.create(date: date);
    newRecord = _fillRecord(newRecord);

    await _recRepo.insert(newRecord);
    ns.showNotification(NNewRecord());
  }

  ChronicleRecord _fillRecord(ChronicleRecord rec) {    
    rec.description = desc;
    rec.group = group;
    rec.charTypes = charTypes;
    rec.date = date;
    rec.hours = hours;
    rec.challenge = challenge;
    rec.favorite = favorite;
    rec.time = DateTime.now().millisecondsSinceEpoch;
    _recalcChars(rec);
    return rec;
  }

  @override
  void dispose() {
    _initController.close();
    super.dispose();
  }
}
