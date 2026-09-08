import 'package:chaos_control/models/project.dart';
import 'package:flutter/material.dart';
import 'package:chaos_control/models/target.dart';

class TargetEditModel extends ChangeNotifier {

  // -------------- Fields ----------------
  Target target = Target.create(title: '', desc: '');
  
  final _targetRepo = TargetRepository();
  final _projectRepo = ProjectRepository();

  List<Project> projects = [];

  String title = '';
  String group = '';
  String desc = '';
  bool favorite = false;

  Project? selectedProject;

  bool isEditing = false;

  // ---------------- Initialization ------------------

  Future setTarget(Target? trg) async {

    projects = await _projectRepo.getAll();
    isEditing = trg != null;
    target = trg ?? Target.create(title: '', desc: '');
    
    title = target.title;
    desc = target.desc;
    group = target.group;
    favorite = target.favorite;
    selectedProject = target.projectId == null ? null : projects.firstWhere((e) => e.id == target.projectId);
    
    notifyListeners();
  }

  // -------------------- Commands ------------------------

  void setTitle(String? value) {
    title = value ?? '';
    notifyListeners();
  }
  void setDesc(String? value) {
    desc = value ?? '';
    notifyListeners();
  }
  void setGroup(String? value) {
    group = value ?? '';
    notifyListeners();
  }
  void setFavorite(bool value) {
    favorite = value;
    notifyListeners();
  }
  void setProject(Project? value) {
    selectedProject = value;
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
        await _targetRepo.delete(target.id);
      } catch (e) {
        // print(e);
      }
    }
  }

  Future<bool> save() async {
    target.title = title;
    target.desc = desc;
    target.group = group;
    target.favorite = favorite;
    target.projectId = selectedProject?.id;
    
    try {
      if (isEditing) {
        await _targetRepo.update(target);
      } else {
        await _targetRepo.insert(target);
      }
    }
    catch (e) {
      // print(e);
      return false;
    }
    return true;
  }
}