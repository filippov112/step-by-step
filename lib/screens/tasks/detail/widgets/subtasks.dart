import 'package:flutter/material.dart';
import 'package:life_game/models/task.dart';
import 'package:life_game/screens/tasks/detail/task_detail_model.dart';
import 'package:life_game/screens/tasks/detail/widgets/tile.dart';
import 'package:life_game/widgets/common/empty_list_screen.dart';

Widget buildSubtaskSection(
  BuildContext context,
  {
    required ExpansibleController expController,
    required VoidCallback onExpansionChanged,
    required List<Task> subtasks,
  }) {
    return ExpansionTile(
      controller: expController,
      onExpansionChanged: (_) { onExpansionChanged.call(); },
      title: Text(
        'Подзадачи (${subtasks.where((e) => e.done).length} / ${subtasks.length})',
        style: Theme.of(context).textTheme.titleMedium,
      ),
      leading: Icon(Icons.task_alt_outlined),
      children: [ 
        
      ],
    );
  }

Widget buildSubtaskBlock(
  BuildContext context,
  {
    required TaskDetailModel model,
    required ExpansibleController expController,
    required VoidCallback onExpansionChanged,
    required List<Task> subtasks,
    required bool isLoading,
    required Map<String,int> childrenCount,
    required Map<String,int> childrenDoneCount,
  }
) {
  return isLoading ? const Center(child: CircularProgressIndicator())
    : subtasks.isEmpty ? EmptyListScreen(
      title: "Подзадач нет", 
      subtitle: "Добавьте подзадачу, чтобы разбить основную на части", 
      icon: Icons.task_alt_outlined
    )
    : SizedBox(
      height: 400, 
      child: Padding(
        padding: EdgeInsetsGeometry.all(8), 
        child: ListView.builder(
          itemCount: subtasks.length,
          itemBuilder: (context, index) {
            return DetailTaskCard(
              model: model, 
              task: subtasks[index], 
              childrenCount: childrenCount[subtasks[index].id] ?? 0, 
              childrenDoneCount: childrenDoneCount[subtasks[index].id] ?? 0
            );
          },
        ),
      ),  
  );
}
