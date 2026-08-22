import 'package:flutter/material.dart';
import 'package:life_game/widgets/dialogs/confirm_dialog.dart';
import 'package:life_game/widgets/common/custom_text.dart';


// AppBar для экранов-списков
PreferredSizeWidget buildMainAppBar<T>(
  BuildContext context, {
  bool isRootWidgetTree = false,
  required String title,
  required bool isSelectionMode,
  required VoidCallback selectAll,
  required Iterable<String> selectedIds,
  required Iterable<T> filteredList,
  PreferredSizeWidget? searchWidget,
  required VoidCallback deleteSelected,
  required VoidCallback clearSelection,
  List<Widget>? actions
}) {

  Future deleteFunc(int itemCount) async {
    if (await showConfirmDialog(context) == true) {
      deleteSelected.call();
    }
  }

  return AppBar(
    title: isSelectionMode 
        ? CustomText('Выбрано: ${selectedIds.length}', size:18) 
        : CustomText(title, size: 18),
    actions: [
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
      ...?actions,
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