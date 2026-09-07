import 'package:chaos_control/models/enums/target_status.dart';
import 'package:chaos_control/models/project.dart';
import 'package:chaos_control/services/datetool.dart';
import 'package:flutter/material.dart';
import 'package:chaos_control/models/enums/target_difficulty.dart';
import 'package:chaos_control/models/target.dart';

class TargetCreateModel extends ChangeNotifier {

  // -------------- Fields ----------------
  Target target = Target.create(title: '', desc: '');
  
  final _targetRepo = TargetRepository();

  String title = '';
  String selectedGroup = '';
  String desc = '';
  bool favorite = false;
  TargetDiff difficulty = TargetDiff.F;
  TargetStatus status = TargetStatus.breaking;

  Project? selectedProject;

  // ---------------- Initialization ------------------

  Future setTarget(Project? project, String group) async {

    target = Target.create(title: '', desc: '');
    
    title = target.title;
    desc = target.desc;
    selectedGroup = group;
    favorite = target.favorite;
    difficulty = target.difficulty;
    status = target.status;
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
  void setStatus(TargetStatus value) {
    status = value;
    notifyListeners();
  }
  void setDifficulty(TargetDiff value) {
    difficulty = value;
    notifyListeners();
  }

  // ---------- CRUD ---------------------

  Future<bool> save() async {
    target.title = title;
    target.desc = desc;
    target.group = selectedGroup;
    target.favorite = favorite;
    target.status = status;
    target.created = DateTool.today();
    target.difficulty = difficulty;
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