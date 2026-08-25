import 'package:flutter/material.dart';
import 'package:chaos_control/widgets/common/custom_text.dart';

class ClassFormSkillTile extends StatelessWidget {

  final String title;
  final bool selected;
  final bool focused;
  final VoidCallback? clickCallback;

  const ClassFormSkillTile({
    super.key,
    required this.title,
    required this.selected,
    required this.focused,
    this.clickCallback
  });
  
  @override
  Widget build(BuildContext context) {

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Container(
        decoration: BoxDecoration(
          color: focused ? Theme.of(context).focusColor.withValues(alpha:0.5) : 
            selected ? Theme.of(context).dividerColor.withValues(alpha: 0.5) 
              : Theme.of(context).dividerColor.withValues(alpha: 0.2),
          borderRadius: BorderRadius.all(Radius.circular(8))
        ),
        child: InkWell(
          canRequestFocus: true,
          enableFeedback: clickCallback != null,
          borderRadius: BorderRadius.all(Radius.circular(8)),
          onTap: clickCallback,
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Тип (класс / навык)
                Icon(Icons.star_border),

                // Название
                CustomText(title, expanded: true, padding: EdgeInsets.symmetric(horizontal: 8),),
              ],
            ),
          ),
        ),
      )
    );
  }
}