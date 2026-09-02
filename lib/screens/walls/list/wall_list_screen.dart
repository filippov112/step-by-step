import 'package:flutter/material.dart';
import 'package:chaos_control/models/wall.dart';
import 'package:chaos_control/screens/walls/form/task_form_screen.dart';
import 'package:chaos_control/screens/walls/list/wall_list_model.dart';
import 'package:chaos_control/screens/walls/list/widgets/date.dart';
import 'package:chaos_control/screens/walls/list/widgets/filter.dart';
import 'package:chaos_control/screens/walls/list/widgets/tile.dart';
import 'package:chaos_control/widgets/common/custom_floating_action_button.dart';
import 'package:chaos_control/widgets/common/empty_list_screen.dart';
import 'package:chaos_control/widgets/common/search_string.dart';
import 'package:chaos_control/widgets/common/app_bar_list.dart';
import 'package:chaos_control/screens/home/widgets/bottom_menu.dart';
import 'package:chaos_control/screens/home/widgets/left_menu.dart';
import 'package:provider/provider.dart';

class WallListScreen extends StatefulWidget {
  const WallListScreen({super.key});

  @override
  State<WallListScreen> createState() => _WallListScreenState();
}

class _WallListScreenState extends State<WallListScreen> {
  final TextEditingController _searchController = TextEditingController();
  late WallListModel model;
  @override
  void initState() {
    super.initState();
    model = context.read<WallListModel>();
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
    return Consumer<WallListModel>(
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
              allItemsCount:model.filteredWalls.length, 
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
    final tasks = context.select<WallListModel, List<Wall>>(
      (model) => model.filteredWalls,
    );
    final selectDate = context.read<WallListModel>().selectDate;
    final selectedDate = context.select<WallListModel, DateTime?>(
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
                    return WallListTile(
                      wall: task,
                    );
                  },
                ),
        ),
      ],
    );
  }
}
