import 'package:flutter/material.dart';
import 'package:chaos_control/models/project.dart';
import 'package:chaos_control/models/other/image.dart';


class ProjectEditModel extends ChangeNotifier {

  // -------------- Fields ----------------
  Project project = Project.create(title: '');
  final _projectRepo = ProjectRepository();
  
  List<Project> records = [];
  String title = '';
  String desc = '';
  String group = '';
  bool hidden = false;
  CustomImageData? icon;

  // ---------------- Initialization ------------------

  void setProject(Project value) {
    project = value;
    icon = project.icon;
    title = project.title;
    desc = project.target;
    group = project.group;
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

  Future delete() async {
    try {
      await _projectRepo.delete(project.id);
    } catch (e) {
      // print(e);
    }
  }

  Future<bool> save() async {
    project.title = title;
    project.target = desc;
    project.icon = icon;
    project.group = group;
    project.hidden = hidden;
    try {
      await _projectRepo.update(project);
    }
    catch (e) {
      // print(e);
      return false;
    }
    return true;
  }
}