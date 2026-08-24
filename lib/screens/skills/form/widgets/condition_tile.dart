import 'package:flutter/material.dart';
import 'package:life_game/models/enums/skill_rang.dart';
import 'package:life_game/models/skill_condition.dart';

class SkillFormConditionTile extends StatelessWidget {
  final SkillCondition condition;
  final VoidCallback editCallback;
  final VoidCallback deleteCallback;

  const SkillFormConditionTile({
    super.key,
    required this.condition,
    required this.editCallback,
    required this.deleteCallback,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 4),
      child: ListTile(
        minTileHeight: 72,
        leading: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: condition.rang.color.withValues(alpha: 0.2),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Center(
            child: Text(
              condition.rang.name,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: condition.rang.color,
              ),
            ),
          ),
        ),
        title: Text(
          condition.description.isNotEmpty
              ? condition.description
              : 'Без описания',
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        subtitle: condition.date != null
            ? Text(
                'Выполнено: ${condition.date!.day}.${condition.date!.month}.${condition.date!.year}',
              )
            : null,
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: Icon(
                Icons.edit,
                color: Theme.of(context).dividerColor,
                size: 20,
              ),
              onPressed: editCallback,
              tooltip: 'Редактировать',
            ),
            IconButton(
              icon: Icon(
                Icons.delete,
                color: Theme.of(context).dividerColor,
                size: 20,
              ),
              onPressed: deleteCallback,
              tooltip: 'Удалить',
            ),
          ],
        ),
      ),
    );
  }
}
