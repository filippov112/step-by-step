import 'package:flutter/material.dart';

PreferredSizeWidget buildAppBar<T>(
  BuildContext context, {
  bool isRootWidgetTree = false,
  required String title,
  required bool isSelectionMode,
  required VoidCallback selectAll,
  required Iterable<String> selectedIds,
  required Iterable<T> filteredList,
  PreferredSizeWidget? searchWidget,
  required VoidCallback deleteSelected,
  required VoidCallback clearSelection
}) {

  Future deleteFunc(int itemCount) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Удаление'),
        content: Text('Вы уверены, что хотите удалить выбранные записи ($itemCount шт.)?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Отмена'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Удалить все'),
          ),
        ],
      ),
    );
    if (confirm == true) {
      deleteSelected.call();
    }
  }

  return AppBar(
    title: isSelectionMode 
        ? Text('Выбрано: ${selectedIds.length}') 
        : Text(title),
    actions: [
      // Кнопка "Назад"
      if (!isRootWidgetTree) IconButton(
        icon: const Icon(Icons.arrow_back_ios),
        onPressed: () => Navigator.pop(context),
      ),

      // Кнопка "Выбрать все" в режиме выделения
      if (isSelectionMode)
        IconButton(
          icon: Icon(
            selectedIds.length == filteredList.length 
                ? Icons.deselect 
                : Icons.select_all,
          ),
          onPressed: selectAll,
          tooltip: 'Выбрать все',
        ),
      // Кнопка удаления выбранных
      if (isSelectionMode)
        IconButton(
          icon: const Icon(Icons.delete_outline),
          onPressed: () => deleteFunc(selectedIds.length),
          tooltip: 'Удалить выбранные',
        ),
      // Кнопка отмены выделения
      if (isSelectionMode)
        IconButton(
          icon: const Icon(Icons.clear),
          onPressed: clearSelection,
          tooltip: 'Отменить выделение',
        ),
      // Фильтры
      Builder(
        builder: (context) => IconButton(
          icon: const Icon(Icons.filter_list),
          tooltip: 'Фильтры',
          onPressed: Scaffold.of(context).openEndDrawer,
        ) 
      ),
    ],
    bottom: searchWidget
  );
}