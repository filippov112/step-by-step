import 'package:flutter/material.dart';
import 'package:chaos_control/widgets/dialogs/confirm_dialog.dart';
import 'package:chaos_control/widgets/common/custom_text.dart';

// AppBar для экранов-списков
class ListAppBar extends StatelessWidget implements PreferredSizeWidget {
  final Widget? searchWidget;
  final bool? visibilitySearch;
  final Function(bool)? setVisibilitySearch;
  final SelectionParams? selectionParams;
  final List<Widget>? actions;
  final String title;

  const ListAppBar({
    super.key,
    required this.title,
    this.searchWidget,
    this.visibilitySearch,
    this.setVisibilitySearch,
    this.selectionParams,
    this.actions,
  });

  @override
  Widget build(BuildContext context) {
    Future deleteFunc(int itemCount) async {
      if (await showConfirmDialog(context) == true) {
        selectionParams?.deleteSelected.call();
      }
    }

    final titleWidget =
        (selectionParams == null || !selectionParams!.isSelectionMode)
        ? CustomText(title, size: 18)
        : CustomText(
            'Выбрано: ${selectionParams!.selectedItemsCount}',
            size: 18,
          );

    final searchField =
        (visibilitySearch != null && visibilitySearch == true) ||
            visibilitySearch == null
        ? searchWidget
        : null;

    final Iterable<Widget>? selectionActions = selectionParams == null
        ? null
        : [
            // Кнопка "Выбрать все" в режиме выделения
            if (selectionParams!.isSelectionMode)
              IconButton(
                icon: Icon(
                  selectionParams!.selectedItemsCount ==
                          selectionParams!.allItemsCount
                      ? Icons.deselect
                      : Icons.select_all,
                ),
                onPressed: selectionParams!.selectAll,
                tooltip: 'Выбрать все',
              ),
            // Кнопка удаления выбранных
            if (selectionParams!.isSelectionMode)
              IconButton(
                icon: const Icon(Icons.delete_outline),
                onPressed: () =>
                    deleteFunc(selectionParams!.selectedItemsCount),
                tooltip: 'Удалить выбранные',
              ),
            // Кнопка отмены выделения
            if (selectionParams!.isSelectionMode)
              IconButton(
                icon: const Icon(Icons.clear),
                onPressed: selectionParams!.clearSelection,
                tooltip: 'Отменить выделение',
              ),
          ];

    return AppBar(
      title: searchField ?? titleWidget,
      actions: [
        ...?selectionActions,
        ...?actions,

        // Поиск
        if (selectionParams?.isSelectionMode != true &&
            searchWidget != null &&
            visibilitySearch != null &&
            setVisibilitySearch != null) ...{
          IconButton(
            color: visibilitySearch == true
                ? Theme.of(context).disabledColor
                : Theme.of(context).focusColor,
            icon: const Icon(Icons.search),
            tooltip: 'Поиск',
            onPressed: () => setVisibilitySearch!(!visibilitySearch!),
          ),
        },
        // Фильтры
        if (selectionParams?.isSelectionMode != true)
          Builder(
            builder: (context) => IconButton(
              icon: const Icon(Icons.filter_list),
              tooltip: 'Фильтры',
              onPressed: Scaffold.of(context).openEndDrawer,
            ),
          ),
      ],
    );
  }

  @override
  Size get preferredSize {
    final double appBarHeight = kToolbarHeight;
    return Size.fromHeight(appBarHeight);
  }
}

// Параметры управления выборкой элементов
class SelectionParams {
  bool isSelectionMode;
  VoidCallback selectAll;
  int selectedItemsCount;
  int allItemsCount;
  VoidCallback deleteSelected;
  VoidCallback clearSelection;

  SelectionParams({
    required this.isSelectionMode,
    required this.selectAll,
    required this.selectedItemsCount,
    required this.allItemsCount,
    required this.deleteSelected,
    required this.clearSelection,
  });
}
