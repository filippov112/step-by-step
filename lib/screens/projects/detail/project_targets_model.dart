import 'package:chaos_control/models/task.dart';
import 'package:chaos_control/models/enums/target_difficulty.dart';
import 'package:chaos_control/models/other/image.dart';
import 'package:chaos_control/models/project.dart';
import 'package:chaos_control/widgets/common/tree_list/tree_list_model.dart';
import 'package:chaos_control/widgets/common/tree_list/tree_record.dart';
import 'package:flutter/material.dart';
import 'package:chaos_control/models/target.dart';

class ProjectTargetsModel {
  final Project project;
  ProjectTargetsModel({required this.project});

  final _targetRepo = TargetRepository();
  final _taskRepo = TaskRepository();

  List<Target> _targets = [];
  List<Target> _filteredList = [];
  Map<String,int> tasks = {};
  List<TreeRecord<Target>> visualList = [];

  final treeListModel = CustomTreeListModel<Target>();
  
  // Состояние фильтрации
  static const bool groupFilter = true;
  
  // Режим выделения
  bool isSelectionMode = false;
  Set<String> selectedIds = {};
  
  bool get hasActiveFilters => false;
  
  // Загрузка данных
  Future loadData() async {
    _targets = await _targetRepo.getByProject(project.id);
    await _loadTasks();
    await _applyFiltersAndSort();
  }

  Future _loadTasks() async {
    final list = await _taskRepo.getByProject(project.id);
    final result = <String,int>{};
    for(var at in list) {
      if (!result.containsKey(at.targetId)) {
        result[at.targetId] = 1;
      } else {
        result[at.targetId] = (result[at.targetId] ?? 0) + 1;
      }
    }
    tasks = result;
  }

  void _reloadList() {
    visualList = treeListModel.openFolder(
      list: transformRecords(), 
      folder: treeListModel.currentFolder,
      groupFilter: groupFilter
    );
  }

  List<TreeRecord<Target>> transformRecords() => _filteredList.map(_buildTreeRecord).toList();

  TreeRecord<Target> _buildTreeRecord(Target target) {
    return TreeRecord<Target>(
      address: _buildAddress(target),
      object: target,
      customIconData: _buildIcon(),
      name: target.title,
      color: target.difficulty.color
    );
  }
  String _buildAddress(Target target) {
    return target.group;
  }
  CustomImageData _buildIcon() {
    return CustomImageData.fromIcon(Icons.folder);
  }
  
  Future openFolder(TreeRecord<Target>? folder) async {
    visualList = treeListModel.openFolder(list: transformRecords(), folder: folder);
  }
  
  // Основная логика фильтрации и сортировки
  Future _applyFiltersAndSort() async {
    var result = List<Target>.from(_targets);
    
    // Сортировка
    result.sort((a, b) => a.title.compareTo(b.title));

    _filteredList = result;
    _reloadList();
  }
}
