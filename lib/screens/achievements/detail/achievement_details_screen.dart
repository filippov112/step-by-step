import 'package:flutter/material.dart';
import 'package:chaos_control/models/achievement.dart';
import 'package:chaos_control/screens/achievements/detail/achievement_details_model.dart';
import 'package:chaos_control/screens/achievements/detail/widgets/desc.dart';
import 'package:chaos_control/screens/achievements/detail/widgets/header.dart';
import 'package:chaos_control/screens/achievements/form/achievement_form_screen.dart';
import 'package:chaos_control/widgets/dialogs/confirm_dialog.dart';
import 'package:provider/provider.dart';

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
    WidgetsBinding.instance.addPostFrameCallback((_) {
      model.setAchievement(widget.achievement);
    });
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

    return Scaffold(
      appBar: AppBar(
        title: const Text('Достижение'),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () => _edit(achievement),
            tooltip: 'Редактировать',
          ),
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: _deleteThis,
            tooltip: 'Удалить',
          ),
        ],
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

  Future _edit(Achievement achi) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AchievementFormScreen(achi: achi),
      ),
    ).then((_) async {
      if (context.mounted) {
        var checkExist = await model.checkExist();
        if (!checkExist) {
          _close();
        } else {
          setState(() {});
        }
      }
    });
  }

  void _close() {
    if (context.mounted) {
      Navigator.pop(context);
    }
  }

  Future _deleteThis() async {
    if (await showConfirmDialog(context) == true && context.mounted) {
      await model.deleteThis();
      _close();
    }
  }
}
