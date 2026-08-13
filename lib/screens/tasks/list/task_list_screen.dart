import 'package:flutter/material.dart';
import 'package:life_game/models/task.dart';
import 'package:life_game/screens/tasks/form/task_form_screen.dart';
import 'package:life_game/screens/tasks/list/task_list_model.dart';
import 'package:life_game/screens/tasks/list/widgets/filter.dart';
import 'package:life_game/screens/tasks/list/widgets/tile.dart';
import 'package:life_game/widgets/common/custom_floating_action_button.dart';
import 'package:life_game/widgets/common/empty_list_screen.dart';
import 'package:life_game/widgets/common/search_string.dart';
import 'package:life_game/widgets/main/main_app_bar.dart';
import 'package:life_game/widgets/main/main_bottom_menu.dart';
import 'package:life_game/widgets/main/main_menu_drawer.dart';
import 'package:provider/provider.dart';

class TaskListScreen extends StatefulWidget {
  const TaskListScreen({super.key});

  @override
  State<TaskListScreen> createState() => _TaskListScreenState();
}

class _TaskListScreenState extends State<TaskListScreen> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<TaskListModel>().loadTasks();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var childrenCount = context.select<TaskListModel,Map<String,int>>((model) => model.childTasksCount);
    var childrenDoneCount = context.select<TaskListModel,Map<String,int>>((model) => model.childDoneTasksCount);

    return Consumer<TaskListModel>(
      builder: (context, model, child) {
        return Scaffold(
          endDrawer: TaskFilters(),
          drawer: const MainMenuDrawer(currentRoute: '/tasks'),
          appBar: buildMainAppBar<Task>(
            context,
            title: 'Задачи',
            isRootWidgetTree: true,
            isSelectionMode: model.isSelectionMode,
            selectAll: model.toggleSelectAll,
            selectedIds: model.selectedIds,
            filteredList: model.tasks,
            searchWidget: _buildSearchWidget(context, model),
            deleteSelected: model.deleteSelectedTasks,
            clearSelection: model.clearSelection,
          ),
          body: _buildBody(context, model, childrenCount, childrenDoneCount),
          floatingActionButton: model.isSelectionMode
              ? null
              : CustomFloatingActionButton(
                  openFormCreate: _openCreateForm,
                  tooltip: 'Создать задачу',
                ),
          bottomNavigationBar: MainBottomMenu(),
        );
      },
    );
  }

  PreferredSizeWidget _buildSearchWidget(
    BuildContext context,
    TaskListModel model,
  ) {
    return buildSearchString(
      placeholder: 'Поиск задач...',
      controller: _searchController,
      value: model.searchQuery,
      clearCallback: model.clearSearch,
      changeCallback: model.setSearchQuery,
    );
  }

  Widget _buildBody(BuildContext context, TaskListModel model, Map<String,int> childrenCount, Map<String,int> childrenDoneCount) {
    if (model.tasks.isEmpty) {
      return EmptyListScreen(
        title: 'Нет задач',
        subtitle: 'Создайте свою первую задачу, нажав на кнопку +',
        icon: Icons.task_alt_outlined,
      );
    }
    if (model.hasActiveFilters && model.tasks.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.filter_alt_off, size: 64, color: Theme.of(context).hintColor),
            const SizedBox(height: 16),
            Text(
              'Нет задач по заданным фильтрам',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            TextButton(
              onPressed: model.clearAllFilters,
              child: const Text('Сбросить фильтры'),
            ),
          ],
        ),
      );
    }
    return ListView.builder(
      padding: const EdgeInsets.all(8),
      itemCount: model.tasks.length,
      itemBuilder: (context, index) {
        final task = model.tasks[index];
        return TaskCard(
          model: model, 
          task: task, 
          childrenCount: childrenCount[task.id] ?? 0, 
          childrenDoneCount: childrenDoneCount[task.id] ?? 0,
        );
      },
    );
  }

  void _openCreateForm() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const TaskFormScreen(),
      ),
    ).then((_) => context.read<TaskListModel>().loadTasks());
  }
}