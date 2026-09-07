import 'package:chaos_control/models/target.dart';
import 'package:chaos_control/screens/projects/detail/project_targets_model.dart';
import 'package:chaos_control/widgets/common/tree_list/tree_record.dart';
import 'package:flutter/material.dart';
import 'package:chaos_control/models/project.dart';

class ProjectDetailModel extends ChangeNotifier {
  final _classRepo = ProjectRepository();

  Project project = Project.create(title: '');
  ProjectTargetsModel? targetsModel;

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
    targetsModel = ProjectTargetsModel(project: project);
    await reloadTargets();
    notifyListeners();
  }

  Future _delete(String id) async {
    await _classRepo.delete(id);
    notifyListeners();
  }

  Future deleteThis() async {
    await _delete(project.id);
  }

  Future reloadTargets() async {
    await targetsModel?.loadData();
    notifyListeners();
  }

  Future openTargetsFolder(TreeRecord<Target> folder) async {
    await targetsModel?.openFolder(folder);
    notifyListeners();
  }
}