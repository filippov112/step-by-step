import 'package:flutter/material.dart';
import 'package:life_game/models/enums/tag_type.dart';
import 'package:life_game/screens/tags/tag_list_model.dart';
import 'package:provider/provider.dart';

class TagFilter extends StatelessWidget {
  const TagFilter({
    super.key
  });


  @override
  Widget build(BuildContext context) {

    var setTypeFilter = context.read<TagListModel>().setTypeFilter;

    return PopupMenuButton<List<TagType>>(
      icon: const Icon(Icons.filter_list),
      
      tooltip: 'Фильтр по типу',
      onSelected: setTypeFilter,
      itemBuilder: (context) => [
        const PopupMenuItem(
          value: [TagType.common, TagType.skill, TagType.achievement, TagType.task],
          child: Text('Все типы'),
        ),
        const PopupMenuItem(
          value: [TagType.common],
          child: Text('Общие'),
        ),
        const PopupMenuItem(
          value: [TagType.skill],
          child: Text('Навыки'),
        ),
        const PopupMenuItem(
          value: [TagType.achievement],
          child: Text('Достижения'),
        ),
        const PopupMenuItem(
          value: [TagType.task],
          child: Text('Задачи'),
        ),
      ],
    );
  }
  
}