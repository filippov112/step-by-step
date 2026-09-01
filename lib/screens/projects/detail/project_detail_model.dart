import 'package:flutter/material.dart';
import 'package:chaos_control/models/project.dart';

class ProjectDetailModel extends ChangeNotifier {
  final _classRepo = ProjectRepository();

  Project project = Project.create(title: '');

  Future<bool> checkExist() async {
    var newRecord = await _classRepo.get(project.id);
    if (newRecord != null) {
      project = newRecord;
      notifyListeners();
      return true;
    }
    return false;
  }


  Future setClass(Project cls) async {
    project = cls;
    notifyListeners();
  }

  Future _delete(String id) async {
    await _classRepo.delete(id);
    notifyListeners();
  }

  Future deleteThis() async {
    await _delete(project.id);
  }
}