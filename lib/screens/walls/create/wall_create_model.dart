import 'package:chaos_control/models/enums/wall_status.dart';
import 'package:chaos_control/models/project.dart';
import 'package:chaos_control/services/datetool.dart';
import 'package:flutter/material.dart';
import 'package:chaos_control/models/enums/wall_difficulty.dart';
import 'package:chaos_control/models/wall.dart';

class WallCreateModel extends ChangeNotifier {

  // -------------- Fields ----------------
  Wall wall = Wall.create(title: '', target: '');
  
  final _wallRepo = WallRepository();

  String title = '';
  String selectedGroup = '';
  String target = '';
  bool favorite = false;
  WallDiff difficulty = WallDiff.F;
  WallStatus status = WallStatus.breaking;

  Project? selectedProject;

  // ---------------- Initialization ------------------

  Future setWall(Project? project, String group) async {

    wall = Wall.create(title: '', target: '');
    
    title = wall.title;
    target = wall.target;
    selectedGroup = group;
    favorite = wall.favorite;
    difficulty = wall.difficulty;
    status = wall.status;
    selectedProject = project;
    
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
  void setFavorite(bool value) {
    favorite = value;
    notifyListeners();
  }
  void setStatus(WallStatus value) {
    status = value;
    notifyListeners();
  }
  void setDifficulty(WallDiff value) {
    difficulty = value;
    notifyListeners();
  }

  // ---------- CRUD ---------------------

  Future<bool> save() async {
    wall.title = title;
    wall.target = target;
    wall.group = selectedGroup;
    wall.favorite = favorite;
    wall.status = status;
    wall.created = DateTool.today();
    wall.difficulty = difficulty;
    wall.projectId = selectedProject?.id;
    
    try {
      await _wallRepo.insert(wall);
    }
    catch (e) {
      // print(e);
      return false;
    }
    return true;
  }
}