import 'package:flutter/material.dart';
import 'package:chaos_control/models/class.dart';
import 'package:chaos_control/screens/achievements/detail/achievement_details_model.dart';
import 'package:chaos_control/screens/classes/detail/class_detail_screen.dart';
import 'package:chaos_control/screens/classes/list/class_list_model.dart';
import 'package:chaos_control/widgets/dialogs/confirm_dialog.dart';
import 'package:chaos_control/widgets/common/custom_image_icon.dart';
import 'package:provider/provider.dart';

class ClassTile extends StatelessWidget {

  final ClassListModel model;
  final Class record;

  const ClassTile({
    super.key, 
    required this.model, 
    required this.record,
  });

  @override
  Widget build(BuildContext context) {

    final isSelected = model.selectedIds.contains(record.id);
    Color? containterColor = Theme.of(context).colorScheme.surfaceContainerHighest.withValues(alpha: 0.9);
    // Gradient containterBorderColor = LinearGradient(
    //   transform: GradientRotation(0.7),
    //   colors: [record.rarity.color.withValues(alpha: 0.5), containterColor],
    //   stops: [0, 0.2]);
    Color titleColor = Theme.of(context).colorScheme.onPrimary;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Container(
        decoration: BoxDecoration(
          // gradient: containterBorderColor,
          borderRadius: BorderRadius.all(Radius.circular(16)),
          color: containterColor,
        ),
        child: InkWell(
          borderRadius: BorderRadius.all(Radius.circular(16)),
          onTap: () {
            if (model.isSelectionMode) {
              model.toggleSelect(record.id);
            } else {
              _openDetails(context, model, record);
            }
          },
          onLongPress: () {
            if (!model.isSelectionMode) {
              model.toggleSelectionMode();
              model.toggleSelect(record.id);
            }
          },
          child: Padding(
            padding: const EdgeInsets.all(0),
            child: Row(
              children: [
                // Чекбокс для выделения или статуса
                Padding(
                  padding: EdgeInsetsGeometry.only(right: 12),
                  child: model.isSelectionMode ? Checkbox(
                      value: isSelected,
                      onChanged: (_) => model.toggleSelect(record.id),
                    ) :
                    Padding(
                      padding: const EdgeInsetsGeometry.fromLTRB(12,12,0,12), 
                      child: CustomImageIcon(
                        record.icon, 
                        altIcon: Icons.school_outlined, 
                        // color: record.rarity.color, 
                        width: 40, height: 40
                      ),
                    ),
                ),
                
                // Информация
                Expanded(
                  child: Text(
                    record.title,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      color: titleColor,
                    ),
                  ),
                ),
                
                if (model.isSelectionMode) ...{
                  SizedBox(width: 8,),
                  IconButton(
                    icon: const Icon(Icons.delete_outline, size: 16),
                    onPressed: () => _deleteAchievement(context, record, model.delete),
                    tooltip: 'Удалить',
                  ),
                }
              ],
            ),
          ),
        ),
      )
    );
  }

  Future<void> _deleteAchievement(BuildContext context, Class record, Future Function(String) deleteAchievement) async {
    if (await showConfirmDialog(context) == true) {
      await deleteAchievement(record.id);
    }
  }


  Future _openDetails(BuildContext context, ClassListModel model, Class record) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ChangeNotifierProvider(
          create: (context) => AchievementDetailsModel(), 
          child: ClassDetailScreen(record: record),
        ),
      ),
    );
    if (context.mounted) model.loadData(); 
  }
}