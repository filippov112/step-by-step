import 'package:flutter/material.dart';
import 'package:life_game/models/class.dart';
import 'package:life_game/models/skill.dart';
import 'package:life_game/models/task_reward.dart';
import 'package:life_game/screens/tasks/form/widgets/reward_dialog.dart';
import 'package:life_game/screens/tasks/form/widgets/reward_tile.dart';


class TaskRewardsSection extends StatelessWidget {

  final List<TaskReward> selectedRewards;
  final Function(List<TaskReward>) setSelectedRewards;
  final List<Skill> skills;
  final List<Class> classes;
  final String taskId;

  const TaskRewardsSection({
    super.key,
    required this.selectedRewards, 
    required this.setSelectedRewards,
    required this.skills,
    required this.classes,
    required this.taskId,
  });

  @override
  Widget build(BuildContext context) {

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Награды',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            IconButton(
              onPressed: () => showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                builder: (context) => RewardDialog(
                  onConfirm: (rewards) => setSelectedRewards(rewards), 
                  taskId: taskId, 
                  selectedRewards: selectedRewards,
                ),
              ),
              icon: const Icon(Icons.add, size: 16),
            ),
          ],
        ),
        Text(
          'Всего: ${sum(selectedRewards.map((r) => r.experience).toList())} EXP / ${sum(selectedRewards.map((r) => r.time).toList())} MIN',
          style: Theme.of(context).textTheme.titleSmall,
        ),
        const SizedBox(height: 8),
        SizedBox(
          height:300,
          child: ListView(children: [
            ...selectedRewards.map((reward) {

              Skill? skill;
              Class? class_;
              if (reward.classId != null) {
                class_ = classes.firstWhere((cls) => cls.id == reward.classId);
              } else {
                skill = skills.firstWhere((skl) => skl.id == reward.skillId);
              }
              bool isClass = class_ != null;
              
              return RewardTile(
                isClass: isClass,
                title: isClass ? class_.title : skill?.title ?? '', 
                exp: reward.experience, 
                time: reward.time, 
                selected: true,
                focused: false,
              );
            })
          ],)
        ),
        if (selectedRewards.isEmpty)
          Text(
            'Награды не добавлены',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: Theme.of(context).hintColor,
            ),
          ),
      ],
    );
  }
  
  int sum(List<int> values) {
    int r = 0;
    for(var v in values) {
      r += v;
    }
    return r;
  }
}




