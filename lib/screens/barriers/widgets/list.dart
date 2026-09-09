import 'package:chaos_control/models/barrier.dart';
import 'package:chaos_control/screens/barriers/bar_form_model.dart';
import 'package:chaos_control/screens/barriers/bar_list_model.dart';
import 'package:chaos_control/screens/barriers/widgets/open_button.dart';
import 'package:chaos_control/screens/barriers/widgets/tile.dart';
import 'package:chaos_control/widgets/common/tree_list/tree_list.dart';
import 'package:chaos_control/widgets/common/tree_list/tree_record.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class BarrierList extends StatelessWidget {
  const BarrierList({super.key});

  Future<void> _delete(
    BuildContext context,
    Barrier? target,
    Future Function(String) deleteCallback,
  ) async {
    if (target == null) return;
    await deleteCallback(target.id);
  }

  @override
  Widget build(BuildContext context) {
    final model = context.read<BarrierListModel>();
    final formModel = context.read<BarrierFormModel>();

    final barriers = context
        .select<BarrierListModel, List<TreeRecord<Barrier>>>((m) => m.barriers);
    final currentAddress = context.select<BarrierListModel, String>(
      (m) => m.listModel.currentAddress,
    );
    final isSelectionMode = context.select<BarrierListModel, bool>(
      (m) => m.isSelectionMode,
    );
    final isFormVisibility = context.select<BarrierListModel, bool>(
      (m) => m.visibilityForm,
    );
    final hasActiveFilters = context.select<BarrierListModel, bool>(
      (m) => m.hasActiveFilters,
    );
    final selectedIds = context.select<BarrierListModel, Set<String>>(
      (m) => m.selectedIds,
    );

    return CustomTreeList<Barrier>(
      clearFilters: hasActiveFilters ? model.clearAllFilters : null,
      currentAddress: currentAddress,
      visualList: barriers,
      tileIcon: Icons.fort,
      openRecordCallback: (b) {
        model.openForm(b);
        formModel.init(b);
      },
      openFolderCallback: model.openFolder,
      deleteCallback: (b) => _delete(context, b, model.delete),
      selectCallback: (b) => model.toggleSelect(b?.id ?? ''),
      selectModeCallback: model.toggleSelectionMode,
      isSelectedCallback: (b) => b != null && selectedIds.contains(b.id),
      isSelectionMode: isSelectionMode,
      floatingButton: isSelectionMode || isFormVisibility ? null : const BarrierListOpenButton(),
      tileFabric: BarrierTreeFabric(),
    );
  }
}
