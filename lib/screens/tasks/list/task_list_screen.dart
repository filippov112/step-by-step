import 'package:flutter/material.dart';
import 'package:chaos_control/models/task.dart';
import 'package:chaos_control/screens/tasks/form/task_form_screen.dart';
import 'package:chaos_control/screens/tasks/list/task_list_model.dart';
import 'package:chaos_control/screens/tasks/list/widgets/date.dart';
import 'package:chaos_control/screens/tasks/list/widgets/filter.dart';
import 'package:chaos_control/screens/tasks/list/widgets/tile.dart';
import 'package:chaos_control/widgets/common/custom_floating_action_button.dart';
import 'package:chaos_control/widgets/common/empty_list_screen.dart';
import 'package:chaos_control/widgets/common/search_string.dart';
import 'package:chaos_control/widgets/common/app_bar_list.dart';
import 'package:chaos_control/screens/home/widgets/bottom_menu.dart';
import 'package:chaos_control/screens/home/widgets/left_menu.dart';
import 'package:provider/provider.dart';

class TaskListScreen extends StatefulWidget {
  const TaskListScreen({super.key});

  @override
  State<TaskListScreen> createState() => _TaskListScreenState();
}

class _TaskListScreenState extends State<TaskListScreen> {
  final TextEditingController _searchController = TextEditingController();
  late TaskListModel model;
  @override
  void initState() {
    super.initState();
    model = context.read<TaskListModel>();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      model.loadTasks();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<TaskListModel>(
      builder: (context, model, child) {
        return Scaffold(
          endDrawer: TaskFilters(),
          drawer: const MainMenuDrawer(),
          appBar: ListAppBar(
            title: 'Задачи',
            selectionParams: SelectionParams(
              isSelectionMode:model.isSelectionMode , 
              selectAll:model.toggleSelectAll , 
              selectedItemsCount:model.selectedIds.length , 
              allItemsCount:model.tasks.length, 
              deleteSelected:model.deleteSelectedTasks, 
              clearSelection:model.clearSelection
            ),
            searchWidget: PreferredSize(
              preferredSize: const Size.fromHeight(60),
              child: SearchString(
                placeholder: 'Поиск задач...',
                controller: _searchController,
                value: model.searchQuery,
                clearCallback: model.clearSearch,
                changeCallback: model.setSearchQuery,
              ),
            ),
          ),
          body: TaskListBody(),
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

  void _openCreateForm() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const TaskFormScreen()),
    ).then((_) => model.loadTasks());
  }
}

class TaskListBody extends StatelessWidget {
  const TaskListBody({super.key});

  @override
  Widget build(BuildContext context) {
    final tasks = context.select<TaskListModel, List<Task>>(
      (model) => model.tasks,
    );
    final childrenCount = context.select<TaskListModel, Map<String, int>>(
      (model) => model.childTasksCount,
    );
    final childrenDoneCount = context.select<TaskListModel, Map<String, int>>(
      (model) => model.childDoneTasksCount,
    );
    final selectDate = context.read<TaskListModel>().selectDate;
    final selectedDate = context.select<TaskListModel, DateTime?>(
      (model) => model.selectedDate,
    );

    return Column(
      children: [
        TaskListDate(selectDate: selectDate, selectedDate: selectedDate),
        Expanded(
          child: tasks.isEmpty
              ? EmptyListScreen(
                  title: 'Все задачи закрыты',
                  subtitle: '',
                  icon: Icons.task_alt_outlined,
                )
              : ListView.builder(
                  padding: const EdgeInsets.all(8),
                  itemCount: tasks.length,
                  itemBuilder: (context, index) {
                    final task = tasks[index];
                    return TaskCard(
                      task: task,
                      childrenCount: childrenCount[task.id] ?? 0,
                      childrenDoneCount: childrenDoneCount[task.id] ?? 0,
                    );
                  },
                ),
        ),
      ],
    );
  }
}
