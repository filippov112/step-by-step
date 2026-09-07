import 'package:chaos_control/models/wall.dart';
import 'package:chaos_control/screens/projects/detail/project_walls_model.dart';
import 'package:chaos_control/widgets/common/tree_list/tree_record.dart';
import 'package:flutter/material.dart';
import 'package:chaos_control/models/project.dart';

class ProjectDetailModel extends ChangeNotifier {
  final _classRepo = ProjectRepository();

  Project project = Project.create(title: '');
  ProjectWallsModel? wallsModel;

  Future<bool> checkExist() async {
    var newRecord = await _classRepo.get(project.id);
    if (newRecord != null) {
      project = newRecord;
      notifyListeners();
      return true;
    }
    return false;
  }

  Future setProject(Project cls) async {
    project = cls;
    wallsModel = ProjectWallsModel(project: project);
    await reloadWalls();
    notifyListeners();
  }

  Future _delete(String id) async {
    await _classRepo.delete(id);
    notifyListeners();
  }

  Future deleteThis() async {
    await _delete(project.id);
  }

  Future reloadWalls() async {
    await wallsModel?.loadData();
    notifyListeners();
  }

  Future openWallsFolder(TreeRecord<Wall> folder) async {
    await wallsModel?.openFolder(folder);
    notifyListeners();
  }
}