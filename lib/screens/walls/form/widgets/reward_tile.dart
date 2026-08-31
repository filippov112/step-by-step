import 'package:flutter/material.dart';
import 'package:chaos_control/widgets/common/custom_text.dart';

class RewardTile extends StatelessWidget {

  final String title;
  final bool isClass;
  final int exp;
  final int time;
  final bool selected;
  final bool focused;
  final VoidCallback? clickCallback;

  const RewardTile({
    super.key,
    required this.title,
    required this.isClass,
    required this.exp,
    required this.time,
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
                Icon(isClass ? Icons.school_rounded : Icons.star_border),

                // Название
                CustomText(title, expanded: true, padding: EdgeInsets.symmetric(horizontal: 8),),

                if (selected)
                  CustomText('$exp / $time', color: Theme.of(context).focusColor)
              ],
            ),
          ),
        ),
      )
    );
  }
}