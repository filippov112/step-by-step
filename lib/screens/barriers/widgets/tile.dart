import 'package:chaos_control/models/barrier.dart';
import 'package:chaos_control/screens/barriers/widgets/tile_folder.dart';
import 'package:chaos_control/screens/barriers/widgets/tile_record.dart';
import 'package:chaos_control/widgets/common/tree_list/tree_record.dart';
import 'package:chaos_control/widgets/common/tree_list/tree_tile.dart';
import 'package:flutter/material.dart';

class BarrierTreeFabric implements TreeTileFabric<Barrier, BarrierTreeTile> {
  @override
  BarrierTreeTile create({
    required TreeRecord<Barrier> record,
    VoidCallback? openCallback,
    VoidCallback? selectCallback,
    VoidCallback? deleteCallback,
    VoidCallback? selectModeCallback,
    bool? isSelected,
    bool? isSelectionMode,
    IconData? customAltIcon,
  }) {
    if (record.isFolder) {
      return BarrierTileFolder(
        record: record,
        isSelected: isSelected ?? false,
        isSelectionMode: isSelectionMode ?? false,
        openCallback: openCallback,
        selectCallback: selectCallback,
        selectModeCallback: selectModeCallback,
        deleteCallback: deleteCallback,
      );
    }
    return BarrierTileRecord(
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

class BarrierTreeTile extends StatelessWidget {
  final TreeRecord<Barrier> record;
  final VoidCallback? openCallback,
      selectCallback,
      deleteCallback,
      selectModeCallback;
  final bool isSelected, isSelectionMode;

  const BarrierTreeTile({
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
