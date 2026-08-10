import 'package:flutter/material.dart';
import 'package:life_game/models/enums/tag_type.dart';
import 'package:life_game/models/tag.dart';
import 'package:life_game/screens/tags/tag_list_model.dart';
import 'package:life_game/screens/tags/widgets/tag_filter.dart';
import 'package:life_game/screens/tags/widgets/tag_search.dart';
import 'package:life_game/screens/tags/widgets/tag_tile.dart';
import 'package:life_game/screens/tags/widgets/tag_edit.dart';
import 'package:life_game/widgets/app_drawer.dart';
import 'package:life_game/widgets/custom_floating_action_button.dart';
import 'package:life_game/widgets/empty_list_screen.dart';
import 'package:provider/provider.dart';


class TagListScreen extends StatefulWidget {
  const TagListScreen({super.key});

  @override
  State<TagListScreen> createState() => _TagListScreenState();
}

class _TagListScreenState extends State<TagListScreen> {
  final TextEditingController _searchController = TextEditingController();


  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }


  Future _showAddDialog() async {
    var model = context.read<TagListModel>();
    var insertTag = model.insertTag;
    final result = await showDialog<Tag>(
      context: context,
      builder: (context) => TagEditDialog(),
    );
    if (result != null) {
      await insertTag.call(result);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Тег добавлен')),
        );
      }
    }
  }

  Future _showEditDialog(Tag tag) async {
    var model = context.read<TagListModel>();
    var updateTag = model.updateTag;
    final result = await showDialog<Tag>(
      context: context,
      builder: (context) => TagEditDialog(tag: tag),
    );
    
    if (result != null) {
      await updateTag.call(result);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Тег обновлен')),
        );
      }
    }
  }

  Future _deleteTag(String id) async {
    var model = context.read<TagListModel>();
    var deleteTag = model.deleteTag;
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Удаление тега'),
        content: const Text('Вы уверены, что хотите удалить этот тег?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Отмена'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Удалить'),
          ),
        ],
      ),
    );
    
    if (confirm == true) {
      await deleteTag.call(id);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Тег удален')),
        );
      }
    }
  }

  Future _deleteSelected(int itemCount) async {
    var model = context.read<TagListModel>();
    var deleteSelected = model.deleteSelected;
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Удаление $itemCount тегов'),
        content: Text('Вы уверены, что хотите удалить выбранные теги ($itemCount шт.)?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Отмена'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Удалить все'),
          ),
        ],
      ),
    );
    if (confirm == true) {
      await deleteSelected.call();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Удалено $itemCount тегов')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    
    var shouldClearSearchController = context.select<TagListModel,bool>((model) => model.shouldClearSearchController);
    if (shouldClearSearchController) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _searchController.clear();
        shouldClearSearchController = false;
      });
    }

    var allTags = context.select<TagListModel,List<Tag>>((model) => model.allTags);
    var filteredTags = context.select<TagListModel,List<Tag>>((model) => model.filteredTags);
    var clearFilters = context.read<TagListModel>().clearFilters;
    var selectedIds = context.select<TagListModel,Set<String>>((model) => model.selectedIds);

    var searchQueryisNotEmpty = context.select<TagListModel,bool>((model) => model.searchQueryisNotEmpty);
    var isSelectionMode = context.select<TagListModel,bool>((model) => model.isSelectionMode);
    var selectedTypeFilter = context.select<TagListModel,TagType?>((model) => model.selectedTypeFilter);
    var selectAll = context.read<TagListModel>().selectAll;
    var clearSelection = context.read<TagListModel>().clearSelection;
    
    return FutureBuilder(
      future: context.read<TagListModel>().loadTags(),
      builder:(BuildContext context, AsyncSnapshot snapshot) {

        Widget filter = TagFilter();

        Widget search = TagSearch( 
            searchController: _searchController,
        );

        PreferredSizeWidget appBar = AppBar(
          leading: Builder(
            builder: (context) => IconButton(
              icon: const Icon(Icons.menu),
              onPressed: () => Scaffold.of(context).openDrawer(),
            ),
          ),
          title: isSelectionMode 
              ? Text('Выбрано: ${selectedIds.length}') 
              : const Text('Теги'),
          actions: [
            // Назад
            IconButton(
              icon: const Icon(Icons.arrow_back_ios),
              onPressed: () => Navigator.pop(context),
            ),

            // Кнопка "Выбрать все" в режиме выделения
            if (isSelectionMode)
              IconButton(
                icon: Icon(
                  selectedIds.length == filteredTags.length 
                      ? Icons.deselect 
                      : Icons.select_all,
                ),
                onPressed: selectAll,
                tooltip: 'Выбрать все',
              ),
            // Кнопка удаления выбранных
            if (isSelectionMode)
              IconButton(
                icon: const Icon(Icons.delete_outline),
                onPressed: () => _deleteSelected(selectedIds.length),
                tooltip: 'Удалить выбранные',
              ),
            // Кнопка отмены выделения
            if (isSelectionMode)
              IconButton(
                icon: const Icon(Icons.clear),
                onPressed: clearSelection,
                tooltip: 'Отменить выделение',
              ),
            // Фильтры
            filter,
            // Сброс фильтров
            if (selectedTypeFilter != null || searchQueryisNotEmpty)
              IconButton(
                icon: const Icon(Icons.clear_all),
                onPressed: clearFilters,
                tooltip: 'Сбросить фильтры',
              ),
          ],
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(60),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: search,
            ),
          ),
        );

        Widget buildBody() {
          if (allTags.isEmpty || filteredTags.isEmpty) {
            return EmptyListScreen(
              title: "Теги не найдены", 
              subtitle: allTags.isEmpty ? "Создайте свой первый тэг" : "Попробуйте изменить параметры поиска", 
              icon: Icons.tag
            );
          }
          return ListView.builder(
            padding: const EdgeInsets.all(8),
            itemCount: filteredTags.length,
            itemBuilder: (context, index) {
              final tag = filteredTags[index];
              final isSelected = selectedIds.contains(tag.id);
              
              return Card(
                margin: const EdgeInsets.symmetric(vertical: 4),
                child: TagTile(
                  isSelected: isSelected, 
                  tag: tag, 
                  deleteTag: _deleteTag, 
                  showEditDialog: _showEditDialog,
                )
              );
            },
          );
        }

        return Scaffold(
          drawer: AppDrawer(currentRoute: '/tags'),
          appBar: appBar,
          body: buildBody(),
          floatingActionButton: CustomFloatingActionButton(openFormCreate: _showAddDialog, tooltip: "Добавить тег"),
        );
      }
    );
  }
}