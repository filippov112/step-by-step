import 'package:chaos_control/models/purport.dart';
import 'package:chaos_control/services/notifications/implementations/n_new_purport.dart';
import 'package:chaos_control/services/notifications/notification_service.dart';
import 'package:flutter/material.dart';

class PurportCreateModel extends ChangeNotifier {
  final ns = NotificationService();

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

  // ---------- CRUD ---------------------

  Future<bool> save() async {
    purport.title = title;
    purport.description = desc;
    purport.group = group;
    try {
      await _purportRepo.insert(purport);
      ns.showNotification(NNewPurport());
    }
    catch (e) {
      // print(e);
      return false;
    }
    return true;
  }
}