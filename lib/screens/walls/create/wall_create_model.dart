import 'package:chaos_control/models/enums/wall_status.dart';
import 'package:chaos_control/models/project.dart';
import 'package:chaos_control/tools/datetime.dart';
import 'package:flutter/material.dart';
import 'package:chaos_control/models/enums/wall_difficulty.dart';
import 'package:chaos_control/models/wall.dart';

class WallCreateModel extends ChangeNotifier {

  // -------------- Fields ----------------
  Wall wall = Wall.create(title: '', target: '');
  
  final _wallRepo = WallRepository();
  final _projectRepo = ProjectRepository();

  List<Project> projects = [];

  String title = '';
  String group = '';
  String target = '';
  bool favorite = false;
  DateTime? created = DateTool.today();
  DateTime? destroyed;
  WallDiff difficulty = WallDiff.F;
  WallStatus status = WallStatus.breaking;

  Project? selectedProject;

  bool isEditing = false;

  // ---------------- Initialization ------------------

  Future setWall(Wall? wll) async {

    projects = await _projectRepo.getAll();
    isEditing = wll != null;
    wall = wll ?? Wall.create(title: '', target: '');
    
    title = wall.title;
    target = wall.target;
    group = wall.group;
    favorite = wall.favorite;
    created = wall.created;
    destroyed = wall.destroyed;
    difficulty = wall.difficulty;
    status = wall.status;
    selectedProject = wall.projectId == null ? null : projects.firstWhere((e) => e.id == wall.projectId);
    
    notifyListeners();
  }

  // -------------------- Commands ------------------------

  void setTitle(String? value) {
    title = value ?? '';
    notifyListeners();
  }
  void setTarget(String? value) {
    target = value ?? '';
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
  void setStatus(WallStatus value) {
    status = value;
    notifyListeners();
  }
  void setCreated(DateTime? value) {
    created = value;
    notifyListeners();
  }
  void setDestroyed(DateTime? value) {
    destroyed = value;
    notifyListeners();
  }
  void setDifficulty(WallDiff value) {
    difficulty = value;
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
        await _wallRepo.delete(wall.id);
      } catch (e) {
        // print(e);
      }
    }
  }

  Future<bool> save() async {
    wall.title = title;
    wall.target = target;
    wall.group = group;
    wall.favorite = favorite;
    wall.status = status;
    wall.created = created;
    wall.destroyed = destroyed;
    wall.difficulty = difficulty;
    wall.projectId = selectedProject?.id;
    
    try {
      if (isEditing) {
        await _wallRepo.update(wall);
      } else {
        await _wallRepo.insert(wall);
      }
    }
    catch (e) {
      // print(e);
      return false;
    }
    return true;
  }
}