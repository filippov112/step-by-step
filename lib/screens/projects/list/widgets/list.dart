import 'package:chaos_control/models/project.dart';
import 'package:chaos_control/screens/projects/detail/project_detail_screen.dart';
import 'package:chaos_control/screens/projects/list/project_list_model.dart';
import 'package:chaos_control/screens/projects/list/widgets/add_button.dart';
import 'package:chaos_control/widgets/common/tree_list/tree_list.dart';
import 'package:chaos_control/widgets/common/tree_list/tree_record.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProjectListList extends StatelessWidget {
  const ProjectListList({super.key});

  Future<void> _delete(
    BuildContext context,
    Project? record,
    Future Function(String) deleteCallback,
  ) async {
    if (record == null) return;
    await deleteCallback(record.id);
  }

  void _open(BuildContext context, Project? record, VoidCallback loadCallback) {
    if (record == null) return;
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ProjectDetailScreen(project: record),
      ),
    ).then((_) { 
      if (context.mounted) loadCallback();
    });
    
  }
  
  @override
  Widget build(BuildContext context) {
    final model = context.read<ProjectListModel>();
    final projects = context
        .select<ProjectListModel, List<TreeRecord<Project>>>(
          (m) => m.visualList,
        );
    final currentAddress = context.select<ProjectListModel, String>(
      (m) => m.treeListModel.currentAddress,
    );
    final isSelectionMode = context.select<ProjectListModel,bool>((m) => m.isSelectionMode);
    final hasActiveFilters = context.select<ProjectListModel,bool>((m) => m.hasActiveFilters);
    final selectedIds = context.select<ProjectListModel, Set<String>>((m) => m.selectedIds);

    return CustomTreeList<Project>(
        clearFilters: hasActiveFilters ? model.clearAllFilters : null,
        emptyTitle: 'Проекты не найдены',
        currentAddress: currentAddress,
        visualList: projects,
        tileIcon: Icons.workspaces,
        openRecordCallback: (project) => _open(context, project, model.loadData),
        openFolderCallback: model.openFolder,
        deleteCallback: (project) => _delete(context, project, model.delete),
        selectCallback: (project) => model.toggleSelect(project?.id ?? ''),
        selectModeCallback: model.toggleSelectionMode,
        isSelectedCallback: (project) =>
            project != null && selectedIds.contains(project.id),
        isSelectionMode: isSelectionMode,
        floatingButton: isSelectionMode
          ? null
          : const ProjectListAddButton(),
      );
  }
}