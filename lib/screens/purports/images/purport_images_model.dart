import 'package:chaos_control/models/pur_image.dart';
import 'package:chaos_control/models/purport.dart';
import 'package:flutter/material.dart';

class PurportImagesModel extends ChangeNotifier {
  final _imageRepo = PurImageRepository();
  Purport? purport;
  List<PurImage> images = [];

  bool isSelectionMode = false;
  Set<String> selectedIds = {};

  // ---------- INIT ---------------
  
  Future init(Purport pur) async {
    purport = pur;
    await _reload();
  }
  Future _reload() async {
    images = await _imageRepo.getByPurport(purport?.id);
  }

  // ----------- CRUD -------------

  Future add(String? path) async {
    if (path == null || purport == null) return;
    final newImage = PurImage.create(purportId: purport?.id ?? '', path: path, name: purport?.title ?? '');
    await _imageRepo.insert(newImage);
    _reload();
    notifyListeners();
  }

  Future deleteAllSelected() async {
    for (final id in selectedIds) {
      await _imageRepo.delete(id);
    }
    selectedIds = {};
    isSelectionMode = false;
    await _reload();
    notifyListeners();
  }

  Future update(PurImage image) async {
    await _imageRepo.update(image);
    await _reload();
    notifyListeners();
  }

  Future delete(String id) async {
    await _imageRepo.delete(id);
    await _reload();
    notifyListeners();
  }

  // ------------ Режим выделения --------------

  void toggleSelectionMode() {
    isSelectionMode = !isSelectionMode;
    if (!isSelectionMode) {
      selectedIds = {};
    }
    notifyListeners();
  }
  void toggleSelectAll() {
    if (selectedIds.length == images.length) {
      selectedIds = {};
    } else {
      selectedIds = images.map((i) => i.id).toSet();
    }
    notifyListeners();
  }

  void toggleSelect(String id) {
    if (!isSelectionMode) toggleSelectionMode();
    final selectedImagesCopy = selectedIds.toSet();
    if (selectedImagesCopy.contains(id)) {
      selectedImagesCopy.remove(id);
    } else {
      selectedImagesCopy.add(id);
    }
    selectedIds = selectedImagesCopy;
    notifyListeners();
  }

  void clearSelection() {
    selectedIds = {};
    isSelectionMode = false;
    notifyListeners();
  }
}
