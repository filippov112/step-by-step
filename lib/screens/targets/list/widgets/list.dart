import 'package:chaos_control/models/target.dart';
import 'package:chaos_control/screens/targets/detail/target_detail_screen.dart';
import 'package:chaos_control/screens/targets/list/target_list_model.dart';
import 'package:chaos_control/screens/targets/list/widgets/add_button.dart';
import 'package:chaos_control/screens/targets/list/widgets/tile.dart';
import 'package:chaos_control/widgets/common/tree_list/tree_list.dart';
import 'package:chaos_control/widgets/common/tree_list/tree_record.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class TargetListList extends StatelessWidget {
  const TargetListList({super.key});

  Future<void> _delete(
    BuildContext context,
    Target? target,
    Future Function(String) deleteCallback,
  ) async {
    if (target == null) return;
    await deleteCallback(target.id);
  }

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
    final model = context.read<TargetListModel>();
    final targets = context
        .select<TargetListModel, List<TreeRecord<Target>>>(
          (m) => m.visualList,
        );
    final currentAddress = context.select<TargetListModel, String>(
      (m) => m.treeListModel.currentAddress,
    );
    final isSelectionMode = context.select<TargetListModel, bool>(
      (m) => m.isSelectionMode,
    );
    final hasActiveFilters = context.select<TargetListModel, bool>(
      (m) => m.hasActiveFilters,
    );
    final selectedIds = context.select<TargetListModel, Set<String>>((m) => m.selectedIds);

    return CustomTreeList<Target>(
      clearFilters: hasActiveFilters ? model.clearAllFilters : null,
      emptyTitle: 'Цели не найдены',
      currentAddress: currentAddress,
      visualList: targets,
      tileIcon: Icons.center_focus_strong,
      openRecordCallback: (trg) => _open(context, trg, model.loadData),
      openFolderCallback: model.openFolder,
      deleteCallback: (trg) => _delete(context, trg, model.delete),
      selectCallback: (trg) => model.toggleSelect(trg?.id ?? ''),
      selectModeCallback: model.toggleSelectionMode,
      isSelectedCallback: (trg) =>
          trg != null && selectedIds.contains(trg.id),
      isSelectionMode: isSelectionMode,
      floatingButton: isSelectionMode ? null : const TargetListAddButton(),
      tileFabric: TargetTreeFabric(),
    );
  }
}
