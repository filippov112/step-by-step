import 'package:flutter/material.dart';
import 'package:chaos_control/models/purport.dart';

class PurportDetailsModel extends ChangeNotifier {
  final PurportRepository _purportRepo = PurportRepository();

  Purport purport = Purport.create(title: '');

  Future<bool> checkExist() async {
    var newRecord = await _purportRepo.get(purport.id);
    if (newRecord != null) {
      await setPurport(newRecord);
      return true;
    }
    return false;
  }


  Future setPurport(Purport p) async {
    purport = p;
    notifyListeners();
  }

  void setDone() async {
    purport.date = purport.date ?? DateTime.now();
    await _update(purport);
    notifyListeners();
  }

  Future _delete(String id) async {
    await _purportRepo.delete(id);
    notifyListeners();
  }

  Future deleteThis() async {
    await _delete(purport.id);
  }

  Future _update(Purport p) async {
    await _purportRepo.update(p);
    notifyListeners();
  }
}