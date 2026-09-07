import 'package:chaos_control/models/wall.dart';
import 'package:chaos_control/screens/projects/detail/project_detail_model.dart';
import 'package:chaos_control/screens/walls/detail/wall_detail_screen.dart';
import 'package:chaos_control/screens/walls/list/widgets/tile.dart';
import 'package:chaos_control/widgets/common/tree_list/tree_list.dart';
import 'package:chaos_control/widgets/common/tree_list/tree_record.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProjectDetailWalls extends StatelessWidget {
  const ProjectDetailWalls({super.key});

  void _open(BuildContext context, Wall? wall, VoidCallback loadCallback) {
    if (wall == null) return;
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => WallDetailsScreen(wall: wall)),
    ).then((_) {
      if (context.mounted) loadCallback();
    });
  }

  @override
  Widget build(BuildContext context) {
    final model = context.read<ProjectDetailModel>();
    final walls = context
        .select<ProjectDetailModel, List<TreeRecord<Wall>>>(
          (m) => m.wallsModel?.visualList ?? [],
        );
    final currentAddress = context.select<ProjectDetailModel, String>(
      (m) => m.wallsModel?.treeListModel.currentAddress ?? '',
    );

    return CustomTreeList<Wall>(
      emptyTitle: 'Стены не найдены',
      currentAddress: currentAddress,
      visualList: walls,
      tileIcon: Icons.fort,
      openRecordCallback: (wll) => _open(context, wll, model.reloadWalls),
      openFolderCallback: model.openWallsFolder,
      tileFabric: WallTreeFabric(),
    );
  }
}
