// lib/widgets/achievement_details.dart
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:life_game/models/achievement.dart';
import 'package:life_game/models/enums/achiev_rar.dart';
import 'package:life_game/models/tag.dart';
import 'package:life_game/screens/achievements/achievement_list_model.dart';
import 'package:life_game/screens/achievements/widgets/achievement_form.dart';
import 'package:life_game/themes/solo_leveling_theme.dart';
import 'package:life_game/widgets/common/confirm_dialog.dart';
import 'package:life_game/widgets/common/custom_image_icon.dart';
import 'package:life_game/widgets/common/custom_text.dart';
import 'package:life_game/widgets/common/tag_chip.dart';
import 'package:provider/provider.dart';

class AchievementDetails extends StatefulWidget {
  final Achievement achievement;

  const AchievementDetails({super.key, required this.achievement});

  @override
  State<AchievementDetails> createState() => _AchievementDetailsState();
}

class _AchievementDetailsState extends State<AchievementDetails> {

  List<Tag> _tags = [];
  bool _isLoading = true;

  Achievement? achievement;

  @override
  void initState() {
    super.initState();
    achievement = widget.achievement;
    _loadTags();
  }

  Future<void> _loadTags() async {
    final viewModel = context.read<AchievementListModel>();
    _tags = await viewModel.getTagsForAchievement(achievement!.id);
    setState(() => _isLoading = false);
  }

  Future<void> _editAchievement() async {
    final result = await showDialog<Achievement>(
      context: context,
      builder: (context) => AchievementForm(achievement: achievement),
    );
    if (result != null && context.mounted) {
      setState(() {
        achievement = result;
      });
    }
  }

  Future<void> _deleteAchievement() async {
    final viewModel = context.read<AchievementListModel>();
    if (await showConfirmDialog(context) == true && context.mounted) {
      await viewModel.deleteAchievement(achievement!.id);
      if (mounted) {
        Navigator.of(context).pop(true);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final ach = achievement;
    final isUnlocked = ach!.date != null;
    final viewModel = context.read<AchievementListModel>();

    return Dialog(
      insetPadding: EdgeInsets.all(12),
      child: Container(
        width: 400,
        padding: const EdgeInsets.all(24),
        
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [

            CustomImageIcon(
              ach.icon, 
              icon: Icons.emoji_events, 
              width: 60, height: 60,
              color: ach.rarity.color
            ),

            // Заголовок с иконкой
   
            const SizedBox(height: 16),
            
            CustomText(
              ach.title, 
              size: 16, 
              align: TextAlign.center, 
              lines: null,
              weight: FontWeight.bold,
              overflow: TextOverflow.visible,
            ),

            const SizedBox(height: 16),
            // Описание
            if (ach.description.isNotEmpty)
              Expanded(
                child: ListView(children: [
                  CustomText(
                    ach.description, 
                    lines: null, 
                    overflow: TextOverflow.visible
                  ),
                ],), 
              ),
            
            // Теги
            if (!_isLoading && _tags.isNotEmpty) ...{
              const SizedBox(height: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: _tags.map((tag) =>TagChip(title: tag.title)).toList(),
                  ),
                ],
              ),
            },
              
            // Дата получения
            if (isUnlocked) ...{
              const SizedBox(height: 12),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.calendar_today,
                    size: 14,
                  ),
                  const SizedBox(width: 8),
                  CustomText(
                    _formatDate(ach.date!)
                  ),
                ],
              ),
            },
              
            // Кнопки действий
            const SizedBox(height: 20),
            Row(
              mainAxisSize: MainAxisSize.max,
              children: [
                if (!isUnlocked)
                  Expanded(
                    flex: 1, 
                    child: IconButton(
                      onPressed: () async {
                        setState(() {
                          ach.date = DateTime.now();
                        });
                        viewModel.updateAchievement(ach);
                      },
                      icon: const Icon(Icons.check),
                    ),
                  ),
                  
                const SizedBox(width: 8),
                Expanded(
                  flex: 1, 
                  child: IconButton(
                    onPressed: _editAchievement,
                    icon: const Icon(Icons.edit),
                  ),
                ),
                
                const SizedBox(width: 4),
                Expanded(
                  flex: 1, 
                  child: IconButton(
                    onPressed: _deleteAchievement,
                    icon: const Icon(Icons.delete),
                    color: Theme.of(context).colorScheme.error,
                    tooltip: 'Удалить',
                  ),
                ),

                const SizedBox(width: 4),
                Expanded(
                  flex: 1, 
                  child: IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.close),
                    tooltip: 'Закрыть',
                  ),
                ),
                
              ],
            ),
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}.${date.month.toString().padLeft(2, '0')}.${date.year}';
  }
}