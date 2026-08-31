import 'package:flutter/material.dart';
import 'package:chaos_control/models/class.dart';
import 'package:chaos_control/models/other/image.dart';


class ClassFormModel extends ChangeNotifier {

  // -------------- Fields ----------------
  Class record = Class.create(title: '');
  final _classRepo = ClassRepository();
  
  List<Class> records = [];
  String selectedTitle = '';
  String selectedDescription = '';
  CustomImageData? selectedIcon;
  bool isEditing = false;

  // ---------------- Initialization ------------------

  void setClass(Class? cls) {
    isEditing = cls != null;
    record = cls ?? Class.create(title: '');
    selectedIcon = record.icon;
    selectedTitle = record.title;
    selectedDescription = record.description;
    notifyListeners();
  }



  // -------------------- Commands ------------------------

  void setTitle(String? title) {
    selectedTitle = title ?? '';
    notifyListeners();
  }
  void setDescription(String? description) {
    selectedDescription = description ?? '';
    notifyListeners();
  }
  void setIcon(CustomImageData? value) {
    selectedIcon = value;
    notifyListeners();
  }

  // ---------- CRUD ---------------------

  Future delete() async {
    if (isEditing) {
      try {
        await _classRepo.delete(record.id);
      } catch (e) {
        // print(e);
      }
    }
  }

  Future<bool> save() async {
    record.title = selectedTitle;
    record.description = selectedDescription;
    record.icon = selectedIcon;
    try {
      if (isEditing) {
        await _classRepo.update(record);
      } else {
        await _classRepo.insert(record);
      }
    }
    catch (e) {
      // print(e);
      return false;
    }
    return true;
  }
}