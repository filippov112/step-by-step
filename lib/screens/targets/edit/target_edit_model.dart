import 'package:chaos_control/models/enums/characteristics.dart';
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
  Map<Characteristic,int>? chars, chars10000;
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
    chars = target.chars;
    _recalcChars10000();
    selectedProject = target.projectId == null ? null : projects.firstWhere((e) => e.id == target.projectId);
    
    notifyListeners();
  }

  void _recalcChars10000() {
    int sum = 0;
    chars10000 = {};
    for(var v in chars?.values ?? <int>[]) {
      sum += v;
    }
    for(var ch in Characteristic.values) {
      chars10000![ch] = ((chars?[ch] ?? 0).toDouble() / (sum == 0 ? 1 : sum) * 10000).toInt();
    }
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
  void setChars(Characteristic selectedChar, int value) {
    chars?[selectedChar] = value;
    final newChars = <Characteristic, int>{};
    for (var ch in Characteristic.values) {
      if (ch == selectedChar) {
        newChars[ch] = value;
      } else {
        newChars[ch] = chars?[ch] ?? 0;
      }
    }
    chars = newChars;
    _recalcChars10000();
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
    
    target.control = ((chars10000?[Characteristic.control] ?? 0).toDouble() / 100).toInt();
    target.perseverance = ((chars10000?[Characteristic.perseverance] ?? 0).toDouble() / 100).toInt();
    target.courage = ((chars10000?[Characteristic.courage] ?? 0).toDouble() / 100).toInt();
    target.durability = ((chars10000?[Characteristic.durability] ?? 0).toDouble() / 100).toInt();
    target.creativity = ((chars10000?[Characteristic.creativity] ?? 0).toDouble() / 100).toInt();

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