import 'package:chaos_control/screens/barriers/bar_list_model.dart';
import 'package:chaos_control/widgets/common/app_bar_list.dart';
import 'package:chaos_control/widgets/common/search_string.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class BarrierListAppbar extends StatelessWidget implements PreferredSizeWidget {
  final TextEditingController searchController;
  const BarrierListAppbar({super.key, required this.searchController});
  
  @override
  Widget build(BuildContext context) {
    final model = context.read<BarrierListModel>();
    final allItemsCount = context.select<BarrierListModel,int>((m) => m.barriers.length);
    final visibilitySearch = context.select<BarrierListModel,bool>((m) => m.visibilitySearch);
    final selectedItemsCount = context.select<BarrierListModel,int>((m) => m.selectedIds.length);
    final isSelectionMode = context.select<BarrierListModel,bool>((m) => m.isSelectionMode); 
    final searchQuery = context.select<BarrierListModel,String>((m) => m.searchQuery); 

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
          placeholder: 'Поиск целей...',
          controller: searchController,
          value: searchQuery,
          clearCallback: model.clearSearch,
          changeCallback: model.setSearchQuery,
        ),
      );
  }

  @override
  Size get preferredSize {
    return Size.fromHeight(kToolbarHeight);
  }
}