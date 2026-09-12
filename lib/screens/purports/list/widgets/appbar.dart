import 'package:chaos_control/screens/purports/list/purport_list_model.dart';
import 'package:chaos_control/widgets/common/app_bar_list.dart';
import 'package:chaos_control/widgets/common/search_string.dart';
import 'package:chaos_control/widgets/common/tree_list/move_dialog.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PurportListAppbar extends StatelessWidget implements PreferredSizeWidget {
  final TextEditingController searchController;
  const PurportListAppbar({super.key, required this.searchController});
  
  @override
  Widget build(BuildContext context) {
    final model = context.read<PurportListModel>();
    final allItemsCount = context.select<PurportListModel,int>((m) => m.purports.length);
    final visibilitySearch = context.select<PurportListModel,bool>((m) => m.visibilitySearch);

    return ListAppBar(
        title: '',
        selectionParams: SelectionParams(
          isSelectionMode: model.isSelectionMode,
          selectAll: model.toggleSelectAll,
          selectedItemsCount: model.selectedIds.length,
          allItemsCount: allItemsCount,
          deleteSelected: model.deleteAllSelected,
          clearSelection: model.clearSelection,
        ),
        visibilitySearch: visibilitySearch,
        setVisibilitySearch: model.setVisibilitySearch,
        searchWidget: SearchString(
          controller: searchController,
          value: model.searchQuery,
          changeCallback: model.setSearchQuery,
        ),
        actions: [
          // Кнопка удаления выбранных
            if (model.isSelectionMode &&  model.selectedIds.isNotEmpty)
              IconButton(
                icon: const Icon(Icons.move_to_inbox),
                onPressed: () => showMoveDialog(context, currentAddress: model.listModel.currentAddress, callback: model.moveAllTo),
                tooltip: 'Переместить выбранные',
              ),
        ],
      );
  }

  @override
  Size get preferredSize {
    return Size.fromHeight(kToolbarHeight);
  }
}