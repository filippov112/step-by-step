import 'package:chaos_control/models/other/image.dart';
import 'package:chaos_control/models/project.dart';
import 'package:flutter/material.dart';

class ProjectCreateModel extends ChangeNotifier {

  // -------------- Fields ----------------
  Project project = Project.create(title: '');
  
  final _projectRepo = ProjectRepository();

  String title = '';
  String group = '';
  String desc = '';
  bool hidden = false;
  CustomImageData? icon;

  // ---------------- Initialization ------------------

  void setProject() {
    project = Project.create(title: '');
    icon = project.icon;
    title = project.title;
    desc = project.target;
    hidden = project.hidden;
    notifyListeners();
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
  void setHidden(bool hidden) {
    this.hidden = hidden;
    notifyListeners();
  }
  void setIcon(CustomImageData? value) {
    icon = value;
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
    project.title = title;
    project.target = desc;
    project.icon = icon;
    project.group = group;
    project.hidden = hidden;
    try {
      await _projectRepo.insert(project);
    }
    catch (e) {
      // print(e);
      return false;
    }
    return true;
  }
}