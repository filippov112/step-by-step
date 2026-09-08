import 'package:chaos_control/models/project.dart';
import 'package:flutter/material.dart';
import 'package:chaos_control/models/target.dart';

class TargetCreateModel extends ChangeNotifier {

  // -------------- Fields ----------------
  Target target = Target.create(title: '', desc: '');
  
  final _targetRepo = TargetRepository();

  String title = '';
  String group = '';
  String desc = '';
  bool favorite = false;

  Project? selectedProject;

  // ---------------- Initialization ------------------

  Future setTarget(Project? project) async {

    target = Target.create(title: '', desc: '');
    
    title = target.title;
    desc = target.desc;
    favorite = target.favorite;
    selectedProject = project;
    
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
  void setFavorite(bool value) {
    favorite = value;
    notifyListeners();
  }
  void setGroup(String? value) {
    group = value ?? '';
    notifyListeners();
  }

  // ---------- CRUD ---------------------

  Future<bool> save() async {
    target.title = title;
    target.desc = desc;
    target.group = group;
    target.favorite = favorite;
    target.projectId = selectedProject?.id;
    
    try {
      await _targetRepo.insert(target);
    }
    catch (e) {
      // print(e);
      return false;
    }
    return true;
  }
}