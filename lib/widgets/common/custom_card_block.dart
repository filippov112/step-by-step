import 'package:flutter/material.dart';
import 'package:chaos_control/widgets/common/custom_text.dart';

// Стандартизированный информационный блок
class CustomCardBlock extends StatelessWidget {
  final Widget child;
  final String? title;
  final Widget? trailing;
  final IconData? icon;
  const CustomCardBlock({super.key, required this.child, this.title, this.trailing, this.icon});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Theme.of(context).dividerColor.withAlpha(25),
        borderRadius: const BorderRadius.all(Radius.circular(16)),
        border: Border.all(color: Theme.of(context).dividerColor, width: 1)
      ),
      child: title == null ? child : Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Заголовок
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [

              // Иконка
              if (icon != null) ...{
                Icon(icon, size: 24),
                const SizedBox(width: 8),
              },
              
              // Название блока
              CustomText(
                title!,
                size: 14,
                color: Theme.of(context).colorScheme.onPrimary,
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
      )
    );
  }
  
}