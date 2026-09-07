import 'package:chaos_control/models/attempt.dart';
import 'package:chaos_control/models/enums/wall_difficulty.dart';
import 'package:chaos_control/models/other/image.dart';
import 'package:chaos_control/models/project.dart';
import 'package:chaos_control/widgets/common/tree_list/tree_list_model.dart';
import 'package:chaos_control/widgets/common/tree_list/tree_record.dart';
import 'package:flutter/material.dart';
import 'package:chaos_control/models/wall.dart';

class ProjectWallsModel {
  final Project project;
  ProjectWallsModel({required this.project});

  final _wallRepo = WallRepository();
  final _attemptRepo = AttemptRepository();

  List<Wall> _walls = [];
  List<Wall> _filteredWalls = [];
  Map<String,int> attempts = {};
  List<TreeRecord<Wall>> visualList = [];

  final treeListModel = CustomTreeListModel<Wall>();
  
  // Состояние фильтрации
  static const bool groupFilter = true;
  
  // Режим выделения
  bool isSelectionMode = false;
  Set<String> selectedIds = {};
  
  bool get hasActiveFilters => false;
  
  // Загрузка данных
  Future loadData() async {
    _walls = await _wallRepo.getByProject(project.id);
    await _loadAttempts();
    await _applyFiltersAndSort();
  }

  Future _loadAttempts() async {
    final list = await _attemptRepo.getByProject(project.id);
    final result = <String,int>{};
    for(var at in list) {
      if (!result.containsKey(at.wallId)) {
        result[at.wallId] = 1;
      } else {
        result[at.wallId] = (result[at.wallId] ?? 0) + 1;
      }
    }
    attempts = result;
  }

  void _reloadList() {
    visualList = treeListModel.openFolder(
      list: transformRecords(), 
      folder: treeListModel.currentFolder,
      groupFilter: groupFilter
    );
  }

  List<TreeRecord<Wall>> transformRecords() => _filteredWalls.map(_buildTreeRecord).toList();

  TreeRecord<Wall> _buildTreeRecord(Wall wall) {
    return TreeRecord<Wall>(
      address: _buildAddress(wall),
      object: wall,
      customIconData: _buildIcon(),
      name: wall.title,
      color: wall.difficulty.color
    );
  }
  String _buildAddress(Wall wall) {
    return wall.group;
  }
  CustomImageData _buildIcon() {
    return CustomImageData.fromIcon(Icons.folder);
  }
  
  Future openFolder(TreeRecord<Wall>? folder) async {
    visualList = treeListModel.openFolder(list: transformRecords(), folder: folder);
  }
  
  // Основная логика фильтрации и сортировки
  Future _applyFiltersAndSort() async {
    var result = List<Wall>.from(_walls);
    
    // Сортировка
    result.sort((a, b) => a.title.compareTo(b.title));

    _filteredWalls = result;
    _reloadList();
  }
}
