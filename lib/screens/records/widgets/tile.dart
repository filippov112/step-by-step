import 'package:chaos_control/models/record.dart';
import 'package:chaos_control/screens/records/widgets/tile_folder.dart';
import 'package:chaos_control/screens/records/widgets/tile_record.dart';
import 'package:chaos_control/widgets/common/tree_list/tree_record.dart';
import 'package:chaos_control/widgets/common/tree_list/tree_tile.dart';
import 'package:flutter/material.dart';

class RecordTreeFabric implements TreeTileFabric<Record, RecordTreeTile> {
  @override
  RecordTreeTile create({
    required TreeRecord<Record> record,
    VoidCallback? openCallback,
    VoidCallback? selectCallback,
    VoidCallback? deleteCallback,
    VoidCallback? selectModeCallback,
    bool? isSelected,
    bool? isSelectionMode,
    IconData? customAltIcon,
  }) {
    if (record.isFolder) {
      return RecordTileFolder(
        record: record,
        isSelected: isSelected ?? false,
        isSelectionMode: isSelectionMode ?? false,
        openCallback: openCallback,
        selectCallback: selectCallback,
        selectModeCallback: selectModeCallback,
        deleteCallback: deleteCallback,
      );
    }
    return RecordTileRecord(
      record: record,
      isSelected: isSelected ?? false,
      isSelectionMode: isSelectionMode ?? false,
      openCallback: openCallback,
      selectCallback: selectCallback,
      selectModeCallback: selectModeCallback,
      deleteCallback: deleteCallback,
    );
  }
}

class RecordTreeTile extends StatelessWidget {
  final TreeRecord<Record> record;
  final VoidCallback? openCallback,
      selectCallback,
      deleteCallback,
      selectModeCallback;
  final bool isSelected, isSelectionMode;

  const RecordTreeTile({
    super.key,
    required this.record,
    this.openCallback,
    this.selectCallback,
    this.selectModeCallback,
    this.deleteCallback,
    required this.isSelected,
    required this.isSelectionMode,
  });

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    throw UnimplementedError();
  }
}
