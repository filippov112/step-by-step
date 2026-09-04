import 'package:chaos_control/screens/walls/list/wall_list_model.dart';
import 'package:chaos_control/widgets/common/app_bar_list.dart';
import 'package:chaos_control/widgets/common/search_string.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class WallListAppbar extends StatelessWidget implements PreferredSizeWidget {
  final TextEditingController searchController;
  const WallListAppbar({super.key, required this.searchController});
  
  @override
  Widget build(BuildContext context) {
    final model = context.read<WallListModel>();
    final allItemsCount = context.select<WallListModel,int>((m) => m.visualList.length);
    final visibilitySearch = context.select<WallListModel,bool>((m) => m.visibilitySearch);
    final selectedItemsCount = context.select<WallListModel,int>((m) => m.selectedIds.length);
    final isSelectionMode = context.select<WallListModel,bool>((m) => m.isSelectionMode); 
    final searchQuery = context.select<WallListModel,String>((m) => m.searchQuery); 

    return ListAppBar(
        title: 'Стены',
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
          placeholder: 'Поиск стен...',
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