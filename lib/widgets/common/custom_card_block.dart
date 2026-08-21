import 'package:flutter/material.dart';

// Стандартизированный информационный блок
class CustomCardBlock extends StatelessWidget {
  final Widget child;
  const CustomCardBlock({super.key, required this.child});

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
      child: child
    );
  }
  
}