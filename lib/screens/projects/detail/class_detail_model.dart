import 'package:flutter/material.dart';
import 'package:chaos_control/models/class.dart';

class ClassDetailModel extends ChangeNotifier {
  final _classRepo = ClassRepository();

  Class record = Class.create(title: '');

  Future<bool> checkExist() async {
    var newRecord = await _classRepo.get(record.id);
    if (newRecord != null) {
      record = newRecord;
      notifyListeners();
      return true;
    }
    return false;
  }


  Future setClass(Class cls) async {
    record = cls;
    notifyListeners();
  }

  Future _delete(String id) async {
    await _classRepo.delete(id);
    notifyListeners();
  }

  Future deleteThis() async {
    await _delete(record.id);
  }
}