import 'package:flutter/material.dart';
import 'package:life_game/models/achievement.dart';
import 'package:life_game/screens/achievements/detail/achievement_details_model.dart';
import 'package:life_game/screens/achievements/detail/widgets/desc.dart';
import 'package:life_game/screens/achievements/detail/widgets/header.dart';
import 'package:life_game/screens/achievements/form/achievement_form_screen.dart';
import 'package:life_game/widgets/common/confirm_dialog.dart';
import 'package:provider/provider.dart';
import 'package:life_game/widgets/common/entity_appbar.dart';

class AchievementDetailScreen extends StatefulWidget {
  final Achievement achievement;
  const AchievementDetailScreen({super.key, required this.achievement});

  @override
  State<AchievementDetailScreen> createState() =>
      _AchievementDetailScreenState();
}

class _AchievementDetailScreenState extends State<AchievementDetailScreen> {
  late AchievementDetailsModel model;

  @override
  void initState() {
    super.initState();
    model = context.read<AchievementDetailsModel>();
    model.setAchievement(widget.achievement);
  }

  @override
  Widget build(BuildContext context) {
    var achievement = context.select<AchievementDetailsModel, Achievement>(
      (model) => model.achievement,
    );

    var date = context.select<AchievementDetailsModel, DateTime?>(
      (model) => model.achievement.date,
    );
    var setDone = model.setDone;
    var deleteThis = model.deleteThis;

    return Scaffold(
      appBar: buildAppBar(
        'Достижение',
        editCallback: () => _edit(model, achievement),
        deleteCallback: () => _deleteThis(deleteThis),
      ),
      body: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          Expanded(
            child: ListView(
              children: [
                Padding(
                  padding: EdgeInsetsGeometry.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [const AchiHeader(), const AchiDescription()],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),

      floatingActionButton: (date == null)
          ? FloatingActionButton(
              onPressed: setDone,
              tooltip: 'Подтвердить получение',
              child: const Icon(Icons.task_alt),
            )
          : null,
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
