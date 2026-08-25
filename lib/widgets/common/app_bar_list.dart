import 'package:flutter/material.dart';
import 'package:life_game/widgets/dialogs/confirm_dialog.dart';
import 'package:life_game/widgets/common/custom_text.dart';

// AppBar для экранов-списков
class ListAppBar extends StatelessWidget implements PreferredSizeWidget {
  final TabBar? tabs;
  final PreferredSizeWidget? searchWidget;
  final SelectionParams? selectionParams;
  final List<Widget>? actions;
  final String title;

  const ListAppBar({
    super.key,
    required this.title,
    this.searchWidget,
    this.selectionParams,
    this.actions,
    this.tabs,
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

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          height: kToolbarHeight + (searchWidget?.preferredSize.height ?? 0),
          child: AppBar(
            title: titleWidget,
            actions: [
              ...?selectionActions,
              ...?actions,
              // Фильтры
              Builder(
                builder: (context) => IconButton(
                  icon: const Icon(Icons.filter_list),
                  tooltip: 'Фильтры',
                  onPressed: Scaffold.of(context).openEndDrawer,
                ),
              ),
            ],
            bottom: searchWidget,
          ),
        ),

        if (tabs != null) Container(child: tabs),
      ],
    );
  }

  @override
  Size get preferredSize {
    final double appBarHeight = kToolbarHeight;
    final double tabBarHeight = tabs == null ? 0 : tabs!.preferredSize.height;
    final double searchHeight = searchWidget == null
        ? 0
        : searchWidget!.preferredSize.height;
    return Size.fromHeight(appBarHeight + tabBarHeight + searchHeight);
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
