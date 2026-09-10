import 'package:chaos_control/models/purport.dart';
import 'package:flutter/material.dart';

class PurportCreateModel extends ChangeNotifier {

  // -------------- Fields ----------------
  Purport purport = Purport.create(title: '');
  
  final _purportRepo = PurportRepository();

  String title = '';
  String group = '';
  String desc = '';

  // ---------------- Initialization ------------------

  void init() {
    purport = Purport.create(title: '');
  }

  // -------------------- Commands ------------------------

  void setTitle(String? value) {
    title = value ?? '';
    notifyListeners();
  }
  void setTarget(String? value) {
    desc = value ?? '';
    notifyListeners();
  }
  void setGroup(String? value) {
    group = value ?? '';
    notifyListeners();
  }

  String? groupValidator(String? text) {
    if (text == null || text.isEmpty) return null;
    var parts = text.split('/');
    if (parts.any((e) => e.isEmpty)) return 'Части группы не могут быть пустыми';
    return null;
  }

  // ---------- CRUD ---------------------

  Future<bool> save() async {
    purport.title = title;
    purport.description = desc;
    purport.group = group;
    try {
      await _purportRepo.insert(purport);
    }
    catch (e) {
      // print(e);
      return false;
    }
    return true;
  }
}