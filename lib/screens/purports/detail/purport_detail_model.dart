import 'package:flutter/material.dart';
import 'package:chaos_control/models/purport.dart';

class PurportDetailModel extends ChangeNotifier {
  final _purRepo = PurportRepository();
  Purport? purport;

  Future<bool> checkExist() async {
    if (purport == null) return false;
    var newRecord = await _purRepo.get(purport!.id);
    if (newRecord != null) {
      purport = newRecord;
      notifyListeners();
      return true;
    }
    return false;
  }

  Future init(Purport cls) async {
    purport = cls;
    notifyListeners();
  }

  Future _delete(String id) async {
    await _purRepo.delete(id);
    notifyListeners();
  }

  Future deleteThis() async {
    if (purport == null) return;
    await _delete(purport!.id);
  }
}