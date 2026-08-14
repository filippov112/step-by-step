import 'package:flutter/material.dart';
import 'package:life_game/models/skill.dart';
import 'package:life_game/models/task_reward.dart';
import 'package:life_game/widgets/filters/reward_dialog.dart';

Widget buildRewardSection(
  BuildContext context,
  {
    required List<TaskReward> selectedRewards, 
    required Function(List<TaskReward>) setSelectedRewards,
    required List<Skill> skills,
    required String taskId,
  }) {
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
            TextButton.icon(
              onPressed: () => _openRewardsSelector(
                context, 
                selectedRewards: selectedRewards, 
                setSelectedRewards: setSelectedRewards, 
                taskId: taskId
              ),
              icon: const Icon(Icons.add, size: 16),
              label: const Text('Указать'),
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
              var skill = skills.firstWhere((skill) => skill.id == reward.skillId);
              return buildTile(
                title: skill.title,
                exp: reward.experience, 
                time: reward.time, 
                selected: true,
                focused: false
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

void _openRewardsSelector(
  BuildContext context, {
  required List<TaskReward> selectedRewards, 
  required Function(List<TaskReward>) setSelectedRewards,
  required String taskId
}) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    builder: (context) => RewardDialog(
      onConfirm: (rewards) => setSelectedRewards(rewards), 
      taskId: taskId, 
      selectedRewards: selectedRewards,
    ),
  );
}