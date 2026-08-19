// lib/widgets/achievement_details.dart
import 'package:flutter/material.dart';
import 'package:life_game/models/achievement.dart';
import 'package:life_game/models/enums/achiev_rar.dart';
import 'package:life_game/models/tag.dart';
import 'package:life_game/screens/achievements/detail/achievement_details_model.dart';
import 'package:life_game/screens/achievements/form/achievement_form_screen.dart';
import 'package:life_game/widgets/common/confirm_dialog.dart';
import 'package:life_game/widgets/common/custom_image_icon.dart';
import 'package:life_game/widgets/common/custom_text.dart';
import 'package:life_game/widgets/common/tag_chip.dart';
import 'package:provider/provider.dart';
import 'package:life_game/widgets/common/entity_appbar.dart';



class AchievementDetailScreen extends StatefulWidget {
  final Achievement achievement;
  const AchievementDetailScreen({super.key, required this.achievement});

  @override
  State<AchievementDetailScreen> createState() => _AchievementDetailScreenState();
}

class _AchievementDetailScreenState extends State<AchievementDetailScreen> {

  late AchievementDetailsModel model;
  
  @override
  void initState() {
    super.initState();
    model = context.read<AchievementDetailsModel>();
    model.setAchievement(widget.achievement);
  }

  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}.${date.month.toString().padLeft(2, '0')}.${date.year}';
  }

  @override
  Widget build(BuildContext context) {

    var achievement = context.select<AchievementDetailsModel,Achievement>((model) => model.achievement);

    var description = context.select<AchievementDetailsModel,String>((model) => model.achievement.description);
    var title = context.select<AchievementDetailsModel,String>((model) => model.achievement.title);
    var icon = context.select<AchievementDetailsModel,String?>((model) => model.achievement.icon);
    var date = context.select<AchievementDetailsModel,DateTime?>((model) => model.achievement.date);
    var rarity = context.select<AchievementDetailsModel,AchievRar>((model) => model.achievement.rarity);
    var tags = context.select<AchievementDetailsModel,List<Tag>>((model) => model.tags);

    var setDone = model.setDone;
    var deleteThis = model.deleteThis;

    return Scaffold(
      appBar: buildAppBar(
        'Достижение', 
        editCallback: () => _edit(model, achievement), 
        deleteCallback: () => _deleteThis(deleteThis)
      ),
      body: Column(
        mainAxisSize: MainAxisSize.max,
        children:[ 
          
          Expanded(
            child: ListView(
              children: [
                Padding(padding: EdgeInsetsGeometry.all(16), child:
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    CustomImageIcon(
                      icon, 
                      icon: Icons.emoji_events, 
                      width: 60, height: 60,
                      color: rarity.color,
                      border: Border.all(color:rarity.color, width: 2),
                    ),

                    // Заголовок с иконкой
          
                    const SizedBox(height: 16),
                
                    CustomText(
                      title, 
                      size: 16, 
                      align: TextAlign.center, 
                      lines: null,
                      weight: FontWeight.bold,
                      overflow: TextOverflow.visible,
                    ),

                    const SizedBox(height: 16),
                    // Описание
                    if (description.isNotEmpty)
                      SizedBox(
                        height: 400,
                        child: ListView(children: [
                          CustomText(
                            description, 
                            lines: null, 
                            overflow: TextOverflow.visible
                          ),
                        ],), 
                      ),
                
                      // Теги
                      if (tags.isNotEmpty) ...{
                        const SizedBox(height: 12),
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: tags.map((tag) =>TagChip(title: tag.title)).toList(),
                        ),
                      },
                  
                      // Дата получения
                      if (date != null) ...{
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
                              _formatDate(date)
                            ),
                          ],
                        ),
                      },
                  
                  ],
                ) ,)
              ],
            ),
          )
        ]
      ),
      
      floatingActionButton: (date == null) ? FloatingActionButton(
        onPressed: setDone,
        tooltip: 'Подтвердить получение',
        child: const Icon(Icons.task_alt),
      ) : null,
    );
  }

  void _edit(AchievementDetailsModel model, Achievement achi) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AchievementFormScreen(achi: achi),
      ),
    ).then((_) async {
      if (context.mounted) {
        var checkExist = await model.checkExist();
        if (!checkExist && context.mounted) {
          Navigator.pop(context);
          return;
        }
      }
    });
  }

  Future _deleteThis(Future Function() deleteThis) async {
    if (await showConfirmDialog(context) == true && context.mounted) {
      await deleteThis();
      if (context.mounted) {
        Navigator.pop(context);
      }
    }
  }
}