import 'package:flutter/material.dart';
import 'package:step_by_step/widgets/common/custom_text.dart';

// Универсальный экран просмотра/редактирования сущности
class EntityScreen extends StatelessWidget {
  final Iterable<Widget>? children;
  final Iterable<Widget>? actions;
  final Widget? floatingButton;
  final VoidCallback? deleteCallback, editCallback, saveCallback;
  final String title;
  final Key? formKey;
  final Widget? child;

  const EntityScreen({
    super.key,
    required this.title,
    this.children,
    this.deleteCallback,
    this.editCallback,
    this.saveCallback,
    this.actions,
    this.formKey,
    this.floatingButton,
    this.child
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
          if (saveCallback != null)
            IconButton(
              icon: const Icon(Icons.save),
              onPressed: saveCallback,
              tooltip: 'Сохранить',
            ),
        ],
      ),

      body: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          Expanded(
            child: child ??
            
            ListView(
              children: [
                Padding(
                  padding: EdgeInsetsGeometry.all(16),
                  child: formKey != null ? 

                  Form(
                    key: formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children:  [...?children],
                    ),
                  )
                  
                  : 
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [...?children],
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
