import 'package:flutter/material.dart';
import 'package:life_game/models/tag.dart';
import 'package:life_game/screens/tags/tag_list_model.dart';
import 'package:life_game/screens/tags/widgets/tag_type_chip.dart';
import 'package:life_game/themes/solo_leveling_theme.dart';
import 'package:life_game/widgets/common/custom_text.dart';
import 'package:provider/provider.dart';

class TagTile extends StatelessWidget {
  const TagTile({
    super.key, 
    required this.isSelected, 
    required this.tag, 
    required this.showEditDialog
  });

  final Tag tag;
  final bool isSelected;
  final Function(Tag) showEditDialog;

  @override
  Widget build(BuildContext context) {

    var isSelectionMode = context.select<TagListModel,bool>((model) => model.isSelectionMode);
    var toggleSelection = context.read<TagListModel>().toggleSelection;

    return ListTile(
      trailing: isSelectionMode
          ? Checkbox(
              value: isSelected,
              onChanged: (_) => toggleSelection(tag.id),
            )
          : TagTypeChip(type: tag.type),
      title: CustomText(
        tag.title,
        weight: isSelected ? FontWeight.bold : FontWeight.normal,
      ),
      onTap: () {
        if (isSelectionMode) {
          toggleSelection(tag.id);
        } else {
          showEditDialog(tag);
        }
      },
      onLongPress: () {
        if (!isSelectionMode) {
          toggleSelection(tag.id);
        }
      },
      selected: isSelected,
      selectedTileColor: Theme.of(context).colorScheme.onPrimary,
    );
  }
  
}