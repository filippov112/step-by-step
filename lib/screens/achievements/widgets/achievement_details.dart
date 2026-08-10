// lib/widgets/achievement_details.dart
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:life_game/models/achievement.dart';
import 'package:life_game/models/enums/achiev_rar.dart';
import 'package:life_game/models/tag.dart';
import 'package:life_game/screens/achievements/achievement_list_model.dart';
import 'package:life_game/screens/achievements/widgets/achievement_form.dart';
import 'package:life_game/themes/solo_leveling_theme.dart';
import 'package:life_game/widgets/tag_chip.dart';
import 'package:provider/provider.dart';

class AchievementDetails extends StatefulWidget {
  final Achievement achievement;

  const AchievementDetails({Key? key, required this.achievement}) : super(key: key);

  @override
  State<AchievementDetails> createState() => _AchievementDetailsState();
}

class _AchievementDetailsState extends State<AchievementDetails> {
  List<Tag> _tags = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadTags();
  }

  Future<void> _loadTags() async {
    final viewModel = context.read<AchievementListModel>();
    _tags = await viewModel.getTagsForAchievement(widget.achievement.id);
    setState(() => _isLoading = false);
  }

  Future<void> _editAchievement() async {
    final result = await showDialog<bool>(
      context: context,
      builder: (context) => AchievementForm(achievement: widget.achievement),
    );
    if (result == true && context.mounted) {
      Navigator.of(context).pop(true);
    }
  }

  Future<void> _deleteAchievement() async {
    final viewModel = context.read<AchievementListModel>();
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Удаление достижения'),
        content: const Text('Вы уверены, что хотите удалить это достижение?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Отмена'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Удалить'),
          ),
        ],
      ),
    );
    if (confirm == true && context.mounted) {
      await viewModel.deleteAchievement(widget.achievement.id);
      if (mounted) {
        Navigator.of(context).pop(true);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final ach = widget.achievement;
    final isUnlocked = ach.date != null;
    final viewModel = context.read<AchievementListModel>();

    return Dialog(
      child: Container(
        width: 400,
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Заголовок с иконкой
            Row(
              children: [
                if (ach.icon != null)
                  Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Theme.of(context).dividerColor),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.file(
                        File(ach.icon!),
                        fit: BoxFit.cover,
                      ),
                    ),
                  )
                else
                  Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      color: Theme.of(context).cardColor,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      Icons.emoji_events,
                      size: 40,
                      color: ach.rarity.color,
                    ),
                  ),
                const SizedBox(width: 16),
                
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        ach.title,
                        style: Theme.of(context).textTheme.titleLarge,
                        overflow: TextOverflow.fade,
                      ),
                      const SizedBox(height: 8),
                      
                      Wrap(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: ach.rarity.color.withValues(alpha: 0.2),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              ach.rarity.displayName,
                              style: TextStyle(
                                fontSize: 12,
                                color: ach.rarity.color,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            // Описание
            if (ach.description.isNotEmpty)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(ach.description),
                ],
              ),
            const SizedBox(height: 12),
            // Теги
            if (!_isLoading && _tags.isNotEmpty)
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
            // Дата получения
            if (isUnlocked) ...{
              const SizedBox(height: 12),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.calendar_today,
                    size: 16,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    _formatDate(ach.date!),
                  ),
                ],
              ),
            },
              
            const SizedBox(height: 20),
            // Кнопки действий
            Row(
              mainAxisSize: MainAxisSize.max,
              children: [
                if (!isUnlocked)
                  Expanded(
                    flex: 1, 
                    child: IconButton(
                      onPressed: () {
                        ach.date = DateTime.now();
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
                    color: Colors.red,
                    tooltip: 'Удалить',
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