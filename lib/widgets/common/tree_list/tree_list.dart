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
  final Function(T?)? deleteCallback, selectCallback;
  final bool Function(T?)? isSelectedCallback;
  final Function(T?)? openRecordCallback;
  final Function(TreeRecord<T>) openFolderCallback;
  final List<TreeRecord<T>> visualList;
  final String currentAddress;
  final bool isSelectionMode;
  final Widget? floatingButton;
  final TreeTileFabric? tileFabric;

  const CustomTreeList({
    super.key,
    required this.visualList,
    required this.currentAddress,
    required this.tileIcon,
    this.emptyTitle,
    this.emptySubtitle,
    this.clearFilters,
    this.deleteCallback,
    this.selectCallback,
    this.selectModeCallback,
    this.openRecordCallback,
    required this.openFolderCallback,
    this.isSelectedCallback,
    this.isSelectionMode = false,
    this.floatingButton,
    this.tileFabric
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
      if (children.isEmpty || isSelectedCallback == null) return false;
      for (var child in children) {
        if(isSelectedCallback?.call(child.object) == false) return false;
      }
      return true;
    }

    final addressColor = Theme.of(context).colorScheme.onPrimary.withAlpha(120);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (currentAddress.isNotEmpty) 
          CustomText(currentAddress, padding: EdgeInsets.fromLTRB(16,8,16,0), color: addressColor),
        Expanded(
          child: Stack(children: [
              emptyMessage ??
              ListView.builder(
                padding: const EdgeInsets.all(8),
                itemCount: visualList.length,
                itemBuilder: (context, index) {
                  final record = visualList[index];

                  final cOpen = record.isFolder
                        ? () => openFolderCallback(record)
                        : (openRecordCallback == null ? null : () => openRecordCallback?.call(record.object));
                  final cSelect = record.isFolder
                        ? () {
                            for (var child in record.children ?? []) {
                              selectCallback?.call(child.object);
                            }
                          }
                        : () => selectCallback?.call(record.object);
                  final cDelete = record.isFolder
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
                          };
                  final isSelected = record.isFolder
                        ? isManySelected(record.children ?? [])
                        : isSelectedCallback?.call(record.object) == true;
                  final customAltIcon = record.isFolder ? Icons.folder : tileIcon;

                  return tileFabric == null ? DefaultTreeTile(
                    record: record,
                    openCallback: cOpen,
                    selectCallback: cSelect,
                    selectModeCallback: selectModeCallback,
                    deleteCallback: cDelete,
                    isSelected: isSelected,
                    isSelectionMode: isSelectionMode,
                    customAltIcon: customAltIcon,
                  ) : 
                  tileFabric!.create(
                    record: record,
                    openCallback: cOpen,
                    selectCallback: cSelect,
                    selectModeCallback: selectModeCallback,
                    deleteCallback: cDelete,
                    isSelected: isSelected,
                    isSelectionMode: isSelectionMode,
                    customAltIcon: customAltIcon,);
                }
              ),
          
            if (floatingButton != null) 
              Positioned(
                right: 20,
                bottom: 20,
                child: floatingButton!
              )
          ],)
              
              
        ),
      ],
    );
  }
}
