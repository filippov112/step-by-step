import 'package:chaos_control/models/purport.dart';
import 'package:chaos_control/screens/purports/detail/purport_detail_screen.dart';
import 'package:chaos_control/screens/purports/images/purport_images_model.dart';
import 'package:chaos_control/screens/purports/list/purport_list_model.dart';
import 'package:chaos_control/screens/purports/list/widgets/add_button.dart';
import 'package:chaos_control/screens/purports/sounds/purport_sounds_model.dart';
import 'package:chaos_control/widgets/common/tree_list/tree_list.dart';
import 'package:chaos_control/widgets/common/tree_list/tree_record.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PurportListList extends StatelessWidget {
  const PurportListList({super.key});

  Future<void> _delete(
    BuildContext context,
    Purport? record,
    Future Function(String) deleteCallback,
  ) async {
    if (record == null) return;
    await deleteCallback(record.id);
  }

  Future _open(BuildContext context, Purport? purport, VoidCallback loadCallback) async {
    if (purport == null) return;
    final imagesModel = context.read<PurportImagesModel>();
    await imagesModel.init(purport);
    if (!context.mounted) return;
    final soundsModel = context.read<PurportSoundsModel>();
    await soundsModel.init(purport);
    if (context.mounted) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => PurportDetailScreen(purport: purport),
        ),
      ).then((_) { 
        if (context.mounted) loadCallback();
      });
    }
  }
  
  @override
  Widget build(BuildContext context) {
    final model = context.read<PurportListModel>();
    final purports = context
        .select<PurportListModel, List<TreeRecord<Purport>>>(
          (m) => m.purports,
        );
    final currentAddress = context.select<PurportListModel, String>(
      (m) => m.listModel.currentAddress,
    );
    final isSelectionMode = context.select<PurportListModel,bool>((m) => m.isSelectionMode);
    final hasActiveFilters = context.select<PurportListModel,bool>((m) => m.hasActiveFilters);
    final selectedIds = context.select<PurportListModel, Set<String>>((m) => m.selectedIds);

    return CustomTreeList<Purport>(
        clearFilters: hasActiveFilters ? model.clearAllFilters : null,
        emptyTitle: 'Смыслов нет!',
        currentAddress: currentAddress,
        visualList: purports,
        tileIcon: Icons.local_fire_department_sharp,
        openRecordCallback: (purport) => _open(context, purport, model.loadData),
        openFolderCallback: model.openFolder,
        deleteCallback: (purport) => _delete(context, purport, model.delete),
        selectCallback: (purport) => model.toggleSelect(purport?.id ?? ''),
        selectModeCallback: model.toggleSelectionMode,
        isSelectedCallback: (purport) =>
            purport != null && selectedIds.contains(purport.id),
        isSelectionMode: isSelectionMode,
        floatingButton: isSelectionMode
          ? null
          : const PurportListAddButton(),
      );
  }
}