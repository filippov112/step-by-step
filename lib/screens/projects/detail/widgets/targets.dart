import 'package:chaos_control/models/target.dart';
import 'package:chaos_control/screens/projects/detail/project_detail_model.dart';
import 'package:chaos_control/screens/targets/detail/target_detail_screen.dart';
import 'package:chaos_control/screens/targets/list/widgets/tile.dart';
import 'package:chaos_control/widgets/common/tree_list/tree_list.dart';
import 'package:chaos_control/widgets/common/tree_list/tree_record.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProjectDetailTargets extends StatelessWidget {
  const ProjectDetailTargets({super.key});

  void _open(BuildContext context, Target? target, VoidCallback loadCallback) {
    if (target == null) return;
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => TargetDetailScreen(target: target)),
    ).then((_) {
      if (context.mounted) loadCallback();
    });
  }

  @override
  Widget build(BuildContext context) {
    final model = context.read<ProjectDetailModel>();
    final targets = context
        .select<ProjectDetailModel, List<TreeRecord<Target>>>(
          (m) => m.targetsModel?.visualList ?? [],
        );
    final currentAddress = context.select<ProjectDetailModel, String>(
      (m) => m.targetsModel?.treeListModel.currentAddress ?? '',
    );

    return CustomTreeList<Target>(
      emptyTitle: 'Цели не найдены',
      currentAddress: currentAddress,
      visualList: targets,
      tileIcon: Icons.center_focus_strong,
      openRecordCallback: (trg) => _open(context, trg, model.reloadTargets),
      openFolderCallback: model.openTargetsFolder,
      tileFabric: TargetTreeFabric(),
    );
  }
}
