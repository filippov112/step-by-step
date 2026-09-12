import 'package:flutter/material.dart';
import 'package:chaos_control/models/purport.dart';


class PurportEditModel extends ChangeNotifier {

  // -------------- Fields ----------------
  Purport? purport;
  final _purportRepo = PurportRepository();
  
  String title = '';
  String desc = '';
  String group = '';

  // ---------------- Initialization ------------------

  void init(Purport value) {
    purport = value;

    title = value.title;
    desc = value.description;
    group = value.group;
  }

  // -------------------- Commands ------------------------

  void setTitle(String? title) {
    this.title = title ?? '';
    notifyListeners();
  }
  void setTarget(String? target) {
    desc = target ?? '';
    notifyListeners();
  }
  void setGroup(String? group) {
    this.group = group ?? '';
    notifyListeners();
  }

  // ---------- CRUD ---------------------

  Future delete() async {
    if (purport == null) return;
    try {
      await _purportRepo.delete(purport!.id);
    } catch (e) {
      // print(e);
    }
  }

  Future<bool> save() async {
    if (purport == null) return false;
    purport?.title = title;
    purport?.description = desc;
    purport?.group = group;
    try {
      await _purportRepo.update(purport!);
    }
    catch (e) {
      // print(e);
      return false;
    }
    return true;
  }
}