import 'package:flutter/material.dart';
import 'package:life_game/models/enums/tag_type.dart';
import 'package:life_game/models/tag.dart';
import 'package:life_game/screens/tags/tag_list_model.dart';
import 'package:life_game/screens/tags/widgets/tag_type_chip.dart';
import 'package:life_game/themes/solo_leveling_theme.dart';
import 'package:provider/provider.dart';

class TagTile extends StatelessWidget {
  const TagTile({
    super.key, 
    required this.isSelected, 
    required this.tag, 
    required this.showEditDialog, 
    required this.deleteTag
  });

  final Tag tag;
  final bool isSelected;
  final Function(Tag) showEditDialog;
  final Function(String) deleteTag;

  @override
  Widget build(BuildContext context) {

    var isSelectionMode = context.select<TagListModel,bool>((model) => model.isSelectionMode);
    var toggleSelection = context.read<TagListModel>().toggleSelection;

    return ListTile(
      leading: isSelectionMode
          ? Checkbox(
              value: isSelected,
              onChanged: (_) => toggleSelection(tag.id),
            )
          : TagTypeChip(type: tag.type),
      title: Text(
        tag.title,
        style: TextStyle(
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          color: SoloLevelingTheme.paleBlue,
        ),
      ),
      trailing: isSelectionMode
          ? null
          : Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: const Icon(Icons.edit, color: SoloLevelingTheme.steelBlue,),
                  onPressed: () => showEditDialog(tag),
                  tooltip: 'Редактировать',
                ),
                IconButton(
                  icon: const Icon(Icons.delete, color: SoloLevelingTheme.steelBlue,),
                  onPressed: () => deleteTag(tag.id),
                  tooltip: 'Удалить',
                ),
              ],
            ),
      onTap: () {
        if (isSelectionMode) {
          toggleSelection(tag.id);
        } else {
          // Можно добавить просмотр тега
        }
      },
      onLongPress: () {
        if (!isSelectionMode) {
          toggleSelection(tag.id);
        }
      },
      selected: isSelected,
      selectedTileColor: Colors.blue.shade50,
    );
  }
  
}