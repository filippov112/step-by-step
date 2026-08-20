import 'package:flutter/material.dart';
import 'package:life_game/widgets/common/custom_text.dart';

// Универсальный экран просмотра/редактирования сущности
class EntityScreen extends StatelessWidget {
  final Iterable<Widget> children;
  final Iterable<Widget>? actions;
  final Widget? floatingButton;
  final VoidCallback? deleteCallback, editCallback;
  final String title;

  const EntityScreen({
    super.key,
    required this.title,
    required this.children,
    this.deleteCallback,
    this.editCallback,
    this.actions,
    this.floatingButton,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: CustomText(title),
        actions: [
          ...?actions,
          if (editCallback != null)
            IconButton(
              icon: const Icon(Icons.edit),
              onPressed: editCallback,
              tooltip: 'Редактировать',
            ),
          if (deleteCallback != null)
            IconButton(
              icon: const Icon(Icons.delete),
              onPressed: deleteCallback,
              tooltip: 'Удалить',
            ),
        ],
      ),

      body: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          Expanded(
            child: ListView(
              children: [
                Padding(
                  padding: EdgeInsetsGeometry.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [...children],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),

      floatingActionButton: floatingButton,
    );
  }
}
