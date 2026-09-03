import 'package:chaos_control/models/wall.dart';
import 'package:chaos_control/screens/walls/detail/wall_detail_screen.dart';
import 'package:chaos_control/screens/walls/list/wall_list_model.dart';
import 'package:chaos_control/screens/walls/list/widgets/add_button.dart';
import 'package:chaos_control/screens/walls/list/widgets/tile.dart';
import 'package:chaos_control/widgets/common/tree_list/tree_list.dart';
import 'package:chaos_control/widgets/common/tree_list/tree_record.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class WallListList extends StatelessWidget {
  const WallListList({super.key});

  Future<void> _delete(
    BuildContext context,
    Wall? wall,
    Future Function(String) deleteCallback,
  ) async {
    if (wall == null) return;
    await deleteCallback(wall.id);
  }

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
    final model = context.read<WallListModel>();
    final walls = context
        .select<WallListModel, List<TreeRecord<Wall>>>(
          (m) => m.visualList,
        );
    final currentAddress = context.select<WallListModel, String>(
      (m) => m.treeListModel.currentAddress,
    );
    final isSelectionMode = context.select<WallListModel, bool>(
      (m) => m.isSelectionMode,
    );
    final hasActiveFilters = context.select<WallListModel, bool>(
      (m) => m.hasActiveFilters,
    );
    final selectedIds = context.select<WallListModel, Set<String>>((m) => m.selectedIds);

    return CustomTreeList<Wall>(
      clearFilters: hasActiveFilters ? model.clearAllFilters : null,
      emptyTitle: 'Стены не найдены',
      currentAddress: currentAddress,
      visualList: walls,
      tileIcon: Icons.fort,
      openRecordCallback: (wll) => _open(context, wll, model.loadData),
      openFolderCallback: model.openFolder,
      deleteCallback: (wll) => _delete(context, wll, model.delete),
      selectCallback: (wll) => model.toggleSelect(wll?.id ?? ''),
      selectModeCallback: model.toggleSelectionMode,
      isSelectedCallback: (wll) =>
          wll != null && selectedIds.contains(wll.id),
      isSelectionMode: isSelectionMode,
      floatingButton: isSelectionMode ? null : const WallListAddButton(),
      tileFabric: WallTreeFabric(),
    );
  }
}
