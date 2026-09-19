import 'package:chaos_control/models/record.dart';
import 'package:chaos_control/screens/records/record_form_model.dart';
import 'package:chaos_control/screens/records/record_list_model.dart';
import 'package:chaos_control/screens/records/widgets/open_button.dart';
import 'package:chaos_control/screens/records/widgets/tile.dart';
import 'package:chaos_control/widgets/common/tree_list/tree_list.dart';
import 'package:chaos_control/widgets/common/tree_list/tree_record.dart';
import 'package:chaos_control/widgets/screens/loading_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class RecordList extends StatelessWidget {
  const RecordList({super.key});

  Future<void> _delete(
    BuildContext context,
    ChronicleRecord? target,
    Future Function(String) deleteCallback,
  ) async {
    if (target == null) return;
    await deleteCallback(target.id);
  }

  @override
  Widget build(BuildContext context) {
    final model = context.read<RecordListModel>();
    final formModel = context.read<RecordFormModel>();

    final records = context
        .select<RecordListModel, List<TreeRecord<ChronicleRecord>>>(
          (m) => m.records,
        );
    final currentAddress = context.select<RecordListModel, String>(
      (m) => m.listModel.currentAddress,
    );
    final isSelectionMode = context.select<RecordListModel, bool>(
      (m) => m.isSelectionMode,
    );
    final isFormVisibility = context.select<RecordListModel, bool>(
      (m) => m.visibilityForm,
    );
    final hasActiveFilters = context.select<RecordListModel, bool>(
      (m) => m.hasActiveFilters,
    );
    final selectedIds = context.select<RecordListModel, Set<String>>(
      (m) => m.selectedIds,
    );
    final selectedRecord = context.select<RecordFormModel, ChronicleRecord?>(
      (m) => m.record,
    );
    final isLoading = context.select<RecordListModel, bool>((m) => m.isLoading);

    final loadingScreen = const CustomLoadingScreen();

    return isLoading
        ? loadingScreen
        : CustomTreeList<ChronicleRecord>(
            clearFilters: hasActiveFilters ? model.clearAllFilters : null,
            currentAddress: currentAddress,
            emptyTitle: 'Смыслы не найдены!',
            visualList: records,
            tileIcon: Icons.auto_stories,
            openRecordCallback: (b) {
              model.openForm(b);
              formModel.init(b, b?.group ?? '');
            },
            openFolderCallback: model.openFolder,
            deleteCallback: (b) => _delete(context, b, model.delete),
            selectCallback: (b) {
              formModel.clearModel();
              model.toggleSelect(b?.id ?? '');
            },
            selectModeCallback: model.toggleSelectionMode,
            isSelectedCallback: (b) =>
                b != null &&
                (selectedRecord?.id == b.id || selectedIds.contains(b.id)),
            isSelectionMode: isSelectionMode,
            floatingButton: isSelectionMode || isFormVisibility
                ? null
                : const RecordListOpenButton(),
            tileFabric: RecordTreeFabric(),
          );
  }
}
