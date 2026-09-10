import 'package:flutter/material.dart';

// Кнопка добавления записей для экранов-списков
class CustomFloatingActionButton extends StatelessWidget {
  
  final VoidCallback callback;
  final String tooltip;

  const CustomFloatingActionButton({super.key, required this.callback, required this.tooltip});

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      heroTag: UniqueKey(),
      onPressed: callback,
      tooltip: tooltip,
      child: const Icon(Icons.add),
    );
  }
  
}