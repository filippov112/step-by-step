import 'package:flutter/material.dart';
import 'package:chaos_control/screens/purports/list/purport_list_model.dart';
import 'package:chaos_control/screens/purports/form/purport_form_screen.dart';
import 'package:chaos_control/screens/purports/list/widgets/filters.dart';
import 'package:chaos_control/screens/purports/list/widgets/tile.dart';
import 'package:chaos_control/widgets/common/app_bar_list.dart';
import 'package:chaos_control/screens/home/widgets/left_menu.dart';
import 'package:chaos_control/screens/home/widgets/bottom_menu.dart';
import 'package:chaos_control/widgets/common/custom_floating_action_button.dart';
import 'package:chaos_control/widgets/common/empty_list_screen.dart';
import 'package:chaos_control/widgets/common/search_string.dart';
import 'package:provider/provider.dart';


class PurportListScreen extends StatefulWidget {
  const PurportListScreen({super.key});

  @override
  State<PurportListScreen> createState() => _PurportListScreenState();
}

class _PurportListScreenState extends State<PurportListScreen> {
  final TextEditingController _searchController = TextEditingController();
  late PurportListModel model;
  @override
  void initState() {
    super.initState();
    model = context.read<PurportListModel>();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      model.loadPurports();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return Consumer<PurportListModel>(
      builder: (context, model, child) {
        return Scaffold(

          appBar: ListAppBar(
              title: 'Смыслы',
              selectionParams: SelectionParams(
                isSelectionMode: model.isSelectionMode,
                selectAll: model.toggleSelectAll,
                selectedItemsCount: model.selectedIds.length,
                allItemsCount: model.purports.length,
                deleteSelected: model.deleteSelectedPurports,
                clearSelection: model.clearSelection,
              ),
              searchWidget: PreferredSize(
                preferredSize: const Size.fromHeight(60),
                child: SearchString(
                  placeholder: 'Поиск смыслов...',
                  controller: _searchController,
                  value: model.searchQuery,
                  clearCallback: model.clearSearch,
                  changeCallback: model.setSearchQuery,
                )
              ),
            ),
          body: _buildBody(context, model),
          floatingActionButton: model.isSelectionMode
              ? null
              : CustomFloatingActionButton(
                  openFormCreate: _openCreateForm,
                  tooltip: 'Добавить смысл',
                ),
          bottomNavigationBar: MainBottomMenu(),
        
          endDrawer: PurportListFilters(),
          drawer: const MainMenuDrawer(),
        );
      }
    );
  }

  Widget _buildBody(BuildContext context, PurportListModel model) {
    if (model.purports.isEmpty) {
      return EmptyListScreen(
        title: 'Нет смыслов',
        subtitle: 'Добавьте смысл, нажав на кнопку +',
        icon: Icons.diamond,
      );
    }
    if (model.hasActiveFilters && model.purports.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.filter_alt_off, size: 64, color: Theme.of(context).hintColor),
            const SizedBox(height: 16),
            Text(
              'Нет смыслов по заданным фильтрам',
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
      itemCount: model.purports.length,
      itemBuilder: (context, index) {
        final purport = model.purports[index];
        return PurportListTile(
          model: model, 
          purport: purport, 
        );
      },
    );
  }

  void _openCreateForm() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PurportFormScreen(),
      ),
    ).then((_) { if (context.mounted) model.loadPurports(); });
  }
}