import 'package:chaos_control/models/project.dart';
import 'package:chaos_control/screens/projects/detail/project_detail_screen.dart';
import 'package:chaos_control/widgets/common/tree_list/tree_list.dart';
import 'package:chaos_control/widgets/common/tree_list/tree_record.dart';
import 'package:flutter/material.dart';
import 'package:chaos_control/screens/projects/form/project_form_screen.dart';
import 'package:chaos_control/screens/projects/list/project_list_model.dart';
import 'package:chaos_control/screens/projects/list/widgets/filters.dart';
import 'package:chaos_control/widgets/common/app_bar_list.dart';
import 'package:chaos_control/widgets/common/custom_floating_action_button.dart';
import 'package:chaos_control/widgets/common/search_string.dart';
import 'package:chaos_control/screens/home/widgets/bottom_menu.dart';
import 'package:chaos_control/screens/home/widgets/left_menu.dart';
import 'package:provider/provider.dart';

class ProjectListScreen extends StatefulWidget {
  const ProjectListScreen({super.key});

  @override
  State<ProjectListScreen> createState() => _ProjectListScreenState();
}

class _ProjectListScreenState extends State<ProjectListScreen> {
  final TextEditingController _searchController = TextEditingController();
  late ProjectListModel model;

  @override
  void initState() {
    super.initState();
    model = context.read<ProjectListModel>();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      model.loadData();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final projects = context
        .select<ProjectListModel, List<TreeRecord<Project>>>(
          (m) => m.visualList,
        );
    final currentAddress = context.select<ProjectListModel, String>(
      (m) => m.treeListModel.currentAddress,
    );

    return Scaffold(
      appBar: ListAppBar(
        title: 'Классы',
        selectionParams: SelectionParams(
          isSelectionMode: model.isSelectionMode,
          selectAll: model.toggleSelectAll,
          selectedItemsCount: model.selectedIds.length,
          allItemsCount: projects.length,
          deleteSelected: model.deleteAllSelected,
          clearSelection: model.clearSelection,
        ),
        searchWidget: PreferredSize(
          preferredSize: const Size.fromHeight(60),
          child: SearchString(
            placeholder: 'Поиск проектов...',
            controller: _searchController,
            value: model.searchQuery,
            clearCallback: model.clearSearch,
            changeCallback: model.setSearchQuery,
          ),
        ),
      ),

      body: CustomTreeList<Project>(
        clearFilters: model.hasActiveFilters ? model.clearAllFilters : null,
        emptyTitle: 'Проекты не найдены',
        currentAddress: currentAddress,
        visualList: projects,
        tileIcon: Icons.star,
        openRecordCallback: _open,
        openFolderCallback: model.openFolder,

        deleteCallback: (project) => _delete(context, project, model.delete),
        selectCallback: (project) => model.toggleSelect(project?.id ?? ''),
        selectModeCallback: model.toggleSelectionMode,
        isSelectedCallback: (project) =>
            project != null && model.selectedIds.contains(project.id),
        isSelectionMode: model.isSelectionMode,
      ),

      floatingActionButton: model.isSelectionMode
          ? null
          : CustomFloatingActionButton(
              openFormCreate: _create,
              tooltip: 'Создать проект',
            ),

      endDrawer: ProjectListFilters(),
      drawer: const MainMenuDrawer(),
      bottomNavigationBar: const MainBottomMenu(),
    );
  }

  Future<void> _delete(
    BuildContext context,
    Project? record,
    Future Function(String) deleteCallback,
  ) async {
    if (record == null) return;
    await deleteCallback(record.id);
  }

  Future _open(Project? record) async {
    if (record == null) return;
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ProjectDetailScreen(project: record),
      ),
    );
    if (context.mounted) model.loadData();
  }

  void _create() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => ProjectFormScreen()),
    ).then((_) {
      if (context.mounted) model.loadData();
    });
  }
}
