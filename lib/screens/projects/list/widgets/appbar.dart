import 'package:chaos_control/screens/projects/list/project_list_model.dart';
import 'package:chaos_control/widgets/common/app_bar_list.dart';
import 'package:chaos_control/widgets/common/search_string.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProjectListAppbar extends StatelessWidget implements PreferredSizeWidget {
  final TextEditingController searchController;
  const ProjectListAppbar({super.key, required this.searchController});

  static const double searchHeight = 60;
  
  @override
  Widget build(BuildContext context) {
    final model = context.read<ProjectListModel>();
    final allItemsCount = context.select<ProjectListModel,int>((m) => m.visualList.length);

    return ListAppBar(
        title: 'Классы',
        selectionParams: SelectionParams(
          isSelectionMode: model.isSelectionMode,
          selectAll: model.toggleSelectAll,
          selectedItemsCount: model.selectedIds.length,
          allItemsCount: allItemsCount,
          deleteSelected: model.deleteAllSelected,
          clearSelection: model.clearSelection,
        ),
        searchWidget: PreferredSize(
          preferredSize: const Size.fromHeight(searchHeight),
          child: SearchString(
            placeholder: 'Поиск проектов...',
            controller: searchController,
            value: model.searchQuery,
            clearCallback: model.clearSearch,
            changeCallback: model.setSearchQuery,
          ),
        ),
      );
  }

  @override
  Size get preferredSize {
    return Size.fromHeight(kToolbarHeight + searchHeight);
  }
}