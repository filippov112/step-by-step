import 'package:flutter/material.dart';
import 'package:chaos_control/widgets/common/custom_text.dart';

// Стандартизированный информационный блок
class CustomCardBlock extends StatelessWidget {
  
  final Widget child;
  final String? title;
  final Widget? trailing;
  final IconData? icon;
  final Color? backColor, borderColor, textColor, iconColor;

  const CustomCardBlock({
    super.key,
    required this.child,
    this.title,
    this.trailing,
    this.icon,
    this.backColor,
    this.borderColor,
    this.iconColor,
    this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: backColor ?? Theme.of(context).dividerColor.withAlpha(25),
        borderRadius: const BorderRadius.all(Radius.circular(16)),
        border: Border.all(
          color: borderColor ?? Theme.of(context).dividerColor,
          width: 1,
        ),
      ),
      child: title == null
          ? child
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Заголовок
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Иконка
                    if (icon != null) ...{
                      Icon(icon, color: iconColor, size: 24),
                      const SizedBox(width: 8),
                    },

                    // Название блока
                    CustomText(
                      title!,
                      size: 14,
                      color:
                          textColor ?? Theme.of(context).colorScheme.onPrimary,
                      expanded: true,
                      weight: FontWeight(500),
                    ),
                    const SizedBox(width: 8),

                    // Кнопки
                    ?trailing,
                  ],
                ),
                const SizedBox(height: 8),

                // Контент
                child,
              ],
            ),
    );
  }
}
