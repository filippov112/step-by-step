import 'package:flutter/material.dart';
import 'package:chaos_control/models/project.dart';
import 'package:chaos_control/models/other/image.dart';


class ProjectFormModel extends ChangeNotifier {

  // -------------- Fields ----------------
  Project record = Project.create(title: '');
  final _classRepo = ProjectRepository();
  
  List<Project> records = [];
  String selectedTitle = '';
  String selectedTarget = '';
  String selectedGroup = '';
  bool selectedHidden = false;
  CustomImageData? selectedIcon;
  bool isEditing = false;

  // ---------------- Initialization ------------------

  void setClass(Project? cls) {
    isEditing = cls != null;
    record = cls ?? Project.create(title: '');
    selectedIcon = record.icon;
    selectedTitle = record.title;
    selectedTarget = record.target;
    selectedGroup = record.group;
    selectedHidden = record.hidden;
    notifyListeners();
  }



  // -------------------- Commands ------------------------

  void setTitle(String? title) {
    selectedTitle = title ?? '';
    notifyListeners();
  }
  void setTarget(String? target) {
    selectedTarget = target ?? '';
    notifyListeners();
  }
  void setGroup(String? group) {
    selectedGroup = group ?? '';
    notifyListeners();
  }
  void setHidden(bool hidden) {
    selectedHidden = hidden;
    notifyListeners();
  }
  void setIcon(CustomImageData? value) {
    selectedIcon = value;
    notifyListeners();
  }
  String? groupValidator(String? text) {
    if (text == null || text.isEmpty) return null;
    var parts = text.split('/');
    if (parts.any((e) => e.isEmpty)) return 'Части группы не могут быть пустыми';
    return null;
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
    record.target = selectedTarget;
    record.icon = selectedIcon;
    record.group = selectedGroup;
    record.hidden = selectedHidden;
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