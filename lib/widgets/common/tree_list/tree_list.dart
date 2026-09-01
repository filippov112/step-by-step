import 'package:chaos_control/widgets/common/custom_text.dart';
import 'package:chaos_control/widgets/common/empty_list_screen.dart';
import 'package:chaos_control/widgets/common/tree_list/tree_record.dart';
import 'package:chaos_control/widgets/common/tree_list/tree_tile.dart';
import 'package:chaos_control/widgets/dialogs/confirm_dialog.dart';
import 'package:flutter/material.dart';

class CustomTreeList<T> extends StatelessWidget {
  final String? emptyTitle, emptySubtitle;
  final IconData tileIcon;
  final VoidCallback? clearFilters, selectModeCallback;
  final Function(T?)? deleteCallback, selectCallback, isSelectedCallback;
  final Function(T?) openRecordCallback;
  final Function(TreeRecord<T>) openFolderCallback;
  final List<TreeRecord<T>> visualList;
  final String currentAddress;
  final bool isSelectionMode;

  const CustomTreeList({
    super.key,
    required this.visualList,
    required this.currentAddress,
    required this.tileIcon,
    this.emptyTitle,
    this.emptySubtitle,
    this.clearFilters,
    required this.deleteCallback,
    required this.selectCallback,
    required this.selectModeCallback,
    required this.openRecordCallback,
    required this.openFolderCallback,
    required this.isSelectedCallback,
    this.isSelectionMode = false,
  });

  @override
  Widget build(BuildContext context) {
    Widget? emptyMessage = emptyTitle != null && visualList.isEmpty
        ? EmptyListScreen(
            title: emptyTitle!,
            subtitle: emptySubtitle ?? '',
            icon: tileIcon,
            clearFilters: clearFilters,
          )
        : null;

    bool isManySelected(List<TreeRecord<T>> children) {
      if (children.isEmpty) return false;
      for (var child in children) {
        if(!isSelectedCallback?.call(child.object)) return false;
      }
      return true;
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (currentAddress.isNotEmpty) 
          CustomText(currentAddress, padding: EdgeInsets.symmetric(horizontal: 16)),
        Expanded(
          child:
              emptyMessage ??
              ListView.builder(
                padding: const EdgeInsets.all(8),
                itemCount: visualList.length,
                itemBuilder: (context, index) {
                  final record = visualList[index];

                  return CustomTreeTile(
                    record: record,
                    openCallback: record.isFolder
                        ? () => openFolderCallback(record)
                        : () => openRecordCallback(record.object),
                    selectCallback: record.isFolder
                        ? () {
                            for (var child in record.children ?? []) {
                              selectCallback?.call(child.object);
                            }
                          }
                        : () => selectCallback?.call(record.object),
                    selectModeCallback: selectModeCallback,
                    deleteCallback: record.isFolder
                        ? () async {
                            if (await showConfirmDialog(context) == true) {
                              for (var child in record.children ?? []) {
                                deleteCallback?.call(child.object);
                              }
                            }
                          }
                        : () async {
                            if (await showConfirmDialog(context) == true) {
                              deleteCallback?.call(record.object);
                            }
                          },
                    isSelected: record.isFolder
                        ? isManySelected(record.children ?? [])
                        : isSelectedCallback?.call(record.object),
                    isSelectionMode: isSelectionMode,
                    customAltIcon: record.isFolder ? Icons.folder : tileIcon,
                  );
                },
              ),
        ),
      ],
    );
  }
}
