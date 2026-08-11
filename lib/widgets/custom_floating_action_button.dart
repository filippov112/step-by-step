import 'package:flutter/material.dart';

// Кнопка добавления записей для экранов-списков
class CustomFloatingActionButton extends StatelessWidget {
  
  final VoidCallback openFormCreate;
  final String tooltip;

  const CustomFloatingActionButton({super.key, required this.openFormCreate, required this.tooltip});

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      heroTag: UniqueKey(),
      onPressed: openFormCreate,
      tooltip: tooltip,
      child: const Icon(Icons.add),
    );
  }
  
}