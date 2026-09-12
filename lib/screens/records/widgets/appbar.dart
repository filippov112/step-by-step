import 'package:chaos_control/screens/records/record_list_model.dart';
import 'package:chaos_control/widgets/common/app_bar_list.dart';
import 'package:chaos_control/widgets/common/search_string.dart';
import 'package:chaos_control/widgets/common/tree_list/move_dialog.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class RecordListAppbar extends StatelessWidget implements PreferredSizeWidget {
  final TextEditingController searchController;
  const RecordListAppbar({super.key, required this.searchController});
  
  @override
  Widget build(BuildContext context) {
    final model = context.read<RecordListModel>();
    final allItemsCount = context.select<RecordListModel,int>((m) => m.records.length);
    final visibilitySearch = context.select<RecordListModel,bool>((m) => m.visibilitySearch);
    final selectedItemsCount = context.select<RecordListModel,int>((m) => m.selectedIds.length);
    final isSelectionMode = context.select<RecordListModel,bool>((m) => m.isSelectionMode); 
    final searchQuery = context.select<RecordListModel,String>((m) => m.searchQuery); 

    return ListAppBar(
        title: '',
        selectionParams: SelectionParams(
          isSelectionMode: isSelectionMode,
          selectAll: model.toggleSelectAll,
          selectedItemsCount: selectedItemsCount,
          allItemsCount: allItemsCount,
          deleteSelected: model.deleteAllSelected,
          clearSelection: model.clearSelection,
        ),
        visibilitySearch: visibilitySearch,
        setVisibilitySearch: model.setVisibilitySearch,
        searchWidget: SearchString(
          controller: searchController,
          value: searchQuery,
          changeCallback: model.setSearchQuery,
        ),
        actions: [
          // Кнопка удаления выбранных
            if (isSelectionMode && selectedItemsCount > 0)
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