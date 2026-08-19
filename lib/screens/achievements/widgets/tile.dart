// final isUnlocked = ach.date != null;
//leading: CustomImageIcon(
//           ach.icon,
//           icon: isUnlocked ? Icons.emoji_events : Icons.lock_outline,
//           width: 40,
//           height: 40,
//           color: ach.rarity.color.withValues(alpha: 0.2)
//         ),
//         title: CustomText(
//           ach.title,
//           size: 15,
//           lines: 2,
//         ),
//         trailing: Container(child:Icon(
//           isUnlocked ? Icons.check_circle : Icons.circle_outlined,
//         ),),


import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:life_game/models/achievement.dart';
import 'package:life_game/models/enums/achiev_rar.dart';
import 'package:life_game/screens/achievements/achievement_list_model.dart';
import 'package:life_game/screens/achievements/detail/achievement_details_model.dart';
import 'package:life_game/screens/achievements/detail/achievement_details_screen.dart';
import 'package:life_game/widgets/common/confirm_dialog.dart';
import 'package:life_game/widgets/common/custom_image_icon.dart';
import 'package:provider/provider.dart';

class AchievementTile extends StatelessWidget {

  final AchievementListModel model;
  final Achievement achi;

  const AchievementTile({
    super.key, 
    required this.model, 
    required this.achi,
  });

  @override
  Widget build(BuildContext context) {

    final isSelected = model.selectedIds.contains(achi.id);
    Color? containterColor = Theme.of(context).colorScheme.surfaceContainerHighest.withValues(alpha: achi.date == null ? 0.2 : 0.9);
    Gradient containterBorderColor = LinearGradient(
      transform: GradientRotation(0.7),
      colors: [achi.rarity.color.withValues(alpha: 0.5), containterColor],
      stops: [0, 0.2]);
    Color titleColor = Theme.of(context).colorScheme.onPrimary;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Container(
        decoration: BoxDecoration(
          gradient: containterBorderColor,
          borderRadius: BorderRadius.all(Radius.circular(16)),
          color: containterColor,
        ),
        child: InkWell(
          borderRadius: BorderRadius.all(Radius.circular(16)),
          onTap: () {
            if (model.isSelectionMode) {
              model.toggleSelectAchievement(achi.id);
            } else {
              _openDetails(context, model, achi);
            }
          },
          onLongPress: () {
            if (!model.isSelectionMode) {
              model.toggleSelectionMode();
              model.toggleSelectAchievement(achi.id);
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
                      onChanged: (_) => model.toggleSelectAchievement(achi.id),
                    ) :
                    Padding(
                      padding: const EdgeInsetsGeometry.fromLTRB(12,12,0,12), 
                      child: CustomImageIcon(
                        achi.icon, 
                        icon: Icons.star_border, 
                        color: achi.rarity.color, 
                        width: 40, height: 40
                      ),
                    ),
                ),
                
                // Информация
                Expanded(
                  child: Text(
                    achi.title,
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
                    onPressed: () => _deleteAchievement(context, achi, model.deleteAchievement),
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

  Future<void> _deleteAchievement(BuildContext context, Achievement achi, Future Function(String) deleteAchievement) async {
    if (await showConfirmDialog(context) == true) {
      await deleteAchievement(achi.id);
    }
  }


  Future _openDetails(BuildContext context, AchievementListModel model, Achievement achi) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ChangeNotifierProvider(
          create: (context) => AchievementDetailsModel(), 
          child: AchievementDetailsScreen(achievement: achi),
        ),
      ),
    );
    if (context.mounted) model.loadAchievements(); 
  }
}