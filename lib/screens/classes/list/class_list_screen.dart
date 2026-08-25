import 'package:flutter/material.dart';
import 'package:chaos_control/screens/classes/form/class_form_screen.dart';
import 'package:chaos_control/screens/classes/list/class_list_model.dart';
import 'package:chaos_control/screens/classes/list/widgets/filters.dart';
import 'package:chaos_control/screens/classes/list/widgets/tile.dart';
import 'package:chaos_control/widgets/common/app_bar_list.dart';
import 'package:chaos_control/widgets/common/custom_floating_action_button.dart';
import 'package:chaos_control/widgets/common/empty_list_screen.dart';
import 'package:chaos_control/widgets/common/search_string.dart';
import 'package:chaos_control/screens/home/widgets/bottom_menu.dart';
import 'package:chaos_control/screens/home/widgets/left_menu.dart';
import 'package:provider/provider.dart';

class ClassListScreen extends StatefulWidget {
  const ClassListScreen({super.key});

  @override
  State<ClassListScreen> createState() => _ClassListScreenState();
}

class _ClassListScreenState extends State<ClassListScreen> {
  final TextEditingController _searchController = TextEditingController();
  late ClassListModel model;

  @override
  void initState() {
    super.initState();
    model = context.read<ClassListModel>();
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
    return Consumer<ClassListModel>(
      builder: (context, model, child) {
        return Scaffold(
          appBar: ListAppBar(
            title: 'Классы',
            selectionParams: SelectionParams(
              isSelectionMode: model.isSelectionMode,
              selectAll: model.toggleSelectAll,
              selectedItemsCount: model.selectedIds.length,
              allItemsCount: model.records.length,
              deleteSelected: model.deleteAllSelected,
              clearSelection: model.clearSelection,
            ),
            searchWidget: PreferredSize(
              preferredSize: const Size.fromHeight(60),
              child: SearchString(
                placeholder: 'Поиск классов...',
                controller: _searchController,
                value: model.searchQuery,
                clearCallback: model.clearSearch,
                changeCallback: model.setSearchQuery,
              ),
            ),
          ),
          body: _buildBody(context, model),
          floatingActionButton: model.isSelectionMode
              ? null
              : CustomFloatingActionButton(
                  openFormCreate: _openCreateForm,
                  tooltip: 'Создать класс',
                ),

          endDrawer: ClassFilters(),
          drawer: const MainMenuDrawer(),
          bottomNavigationBar: const MainBottomMenu(),
        );
      },
    );
  }

  Widget _buildBody(BuildContext context, ClassListModel model) {
    if (model.records.isEmpty) {
      return EmptyListScreen(
        title: 'Классы не найдены',
        subtitle: 'Создайте класс, нажав на кнопку +',
        icon: Icons.school_outlined,
      );
    }
    if (model.hasActiveFilters && model.records.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.filter_alt_off,
              size: 64,
              color: Theme.of(context).hintColor,
            ),
            const SizedBox(height: 16),
            Text(
              'Нет классов по заданным фильтрам',
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
      itemCount: model.records.length,
      itemBuilder: (context, index) {
        final record = model.records[index];
        return ClassTile(model: model, record: record);
      },
    );
  }

  void _openCreateForm() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => ClassFormScreen()),
    ).then((_) {
      if (context.mounted) model.loadData();
    });
  }
}
