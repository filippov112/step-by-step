import 'package:flutter/material.dart';
import 'package:life_game/models/enums/tag_type.dart';
import 'package:life_game/models/tag.dart';
import 'package:life_game/screens/tags/tag_list_model.dart';
import 'package:life_game/widgets/filters/filters_drawer.dart';
import 'package:life_game/screens/tags/widgets/tag_tile.dart';
import 'package:life_game/screens/tags/widgets/tag_edit.dart';
import 'package:life_game/widgets/main/main_app_bar.dart';
import 'package:life_game/widgets/main/main_menu_drawer.dart';
import 'package:life_game/widgets/common/custom_floating_action_button.dart';
import 'package:life_game/widgets/common/empty_list_screen.dart';
import 'package:life_game/widgets/common/search_string.dart';
import 'package:provider/provider.dart';


class TagListScreen extends StatefulWidget {
  const TagListScreen({super.key});

  @override
  State<TagListScreen> createState() => _TagListScreenState();
}

class _TagListScreenState extends State<TagListScreen> {
  final TextEditingController _searchController = TextEditingController();
  String searchQuery = '';

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

  Future _deleteSelected() async {
    var model = context.read<TagListModel>();
    int count = model.selectedIds.length;
    var deleteSelected = model.deleteSelected;
    await deleteSelected.call();
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Удалено $count тегов')),
      );
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
    var selectedIds = context.select<TagListModel,Set<String>>((model) => model.selectedIds);

    var isSelectionMode = context.select<TagListModel,bool>((model) => model.isSelectionMode);
    var selectAll = context.read<TagListModel>().selectAll;
    var clearSelection = context.read<TagListModel>().clearSelection;

    var updateSearch = context.read<TagListModel>().updateSearch;
    
    return FutureBuilder(
      future: context.read<TagListModel>().loadTags(),
      builder:(BuildContext context, AsyncSnapshot snapshot) {

        PreferredSizeWidget appBar = buildMainAppBar(
          context, 
          isSelectionMode: isSelectionMode, 
          title: 'Теги',
          selectAll: selectAll, 
          selectedIds: selectedIds, 
          filteredList: filteredTags, 
          deleteSelected: _deleteSelected, 
          clearSelection: clearSelection,
          searchWidget: PreferredSize(
            preferredSize: const Size.fromHeight(60),
            child: SearchString(
              placeholder: 'Поиск тегов...', 
              controller: _searchController, 
              value: searchQuery, 
              clearCallback: () { updateSearch.call(''); searchQuery = '';}, 
              changeCallback: (val) { updateSearch.call(val); searchQuery = val;}
            )
          ),
          isRootWidgetTree:false
        );
        
        var statusFilterValue = context.select<TagListModel,List<TagType>?>((model) => model.selectedTypeFilter);
        var setTypeFilter = context.read<TagListModel>().setTypeFilter;

        var tagTypeFilter = Padding(
          padding: EdgeInsetsGeometry.fromLTRB(16,0,16,0), 
          child: DropdownButtonFormField<List<TagType>>(
            items: [
              const DropdownMenuItem(
                value: [TagType.common, TagType.skill, TagType.achievement, TagType.task],
                child: Text('Все типы'),
              ),
              const DropdownMenuItem(
                value: [TagType.common],
                child: Text('Общие'),
              ),
              const DropdownMenuItem(
                value: [TagType.skill],
                child: Text('Навыки'),
              ),
              const DropdownMenuItem(
                value: [TagType.achievement],
                child: Text('Достижения'),
              ),
              const DropdownMenuItem(
                value: [TagType.task],
                child: Text('Задачи'),
              ),
            ], 
            initialValue: statusFilterValue, 
            onChanged: setTypeFilter,
          ),
        );

        List<Widget> filters = [tagTypeFilter, ];

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
                  showEditDialog: _showEditDialog,
                )
              );
            },
          );
        }

        return Scaffold(
          drawer: MainMenuDrawer(currentModule: AppModule.tags),
          appBar: appBar,
          endDrawer: FiltersDrawer(filters: filters,),
          body: buildBody(),
          floatingActionButton: CustomFloatingActionButton(openFormCreate: _showAddDialog, tooltip: "Добавить тег"),
        );
      }
    );
  }
}