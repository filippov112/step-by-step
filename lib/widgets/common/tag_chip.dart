import 'package:flutter/material.dart';

// Стилизация отображения тегов в сущностях связанных с тегами (достижения, навыки, задачи)
class TagChip extends StatelessWidget {

  final String title;

  const TagChip({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(12)),
        color: Theme.of(context).dividerColor
      ),
      child: Wrap(
        crossAxisAlignment: WrapCrossAlignment.center,
        // mainAxisSize: MainAxisSize.min,
        // crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(Icons.tag, size: 14),
          const SizedBox(width: 4),
          Text(
            title,
            style: TextStyle(
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
  
}