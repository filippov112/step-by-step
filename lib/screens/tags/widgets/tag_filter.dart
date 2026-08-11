import 'package:flutter/material.dart';
import 'package:life_game/models/enums/tag_type.dart';
import 'package:life_game/screens/tags/tag_list_model.dart';
import 'package:provider/provider.dart';


class TagFilter extends StatefulWidget {

  const TagFilter({
    super.key,
  });

  @override
  State<TagFilter> createState() => _TagFilterState();
}

class _TagFilterState extends State<TagFilter> {

  @override
  Widget build(BuildContext context) {

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

    return Drawer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding:EdgeInsetsGeometry.all(16), 
            child: Row(
              children: [
                IconButton(
                  onPressed: () => Navigator.of(context).pop(), 
                  icon: Icon(Icons.arrow_forward_ios)
                )
              ],
            ),
          ),
          tagTypeFilter,

          
        ],
      )
    );
  }
}