import 'package:chaos_control/models/pur_image.dart';
import 'package:chaos_control/models/purport.dart';
import 'package:flutter/material.dart';

class PurportImagesModel extends ChangeNotifier {
  final _imageRepo = PurImageRepository();
  Purport? purport;
  List<PurImage> images = [];
  bool isLoading = false;

  bool isSelectionMode = false;
  Set<String> selectedIds = {};

  // ---------- INIT ---------------
  
  Future init(Purport pur) async {
    purport = pur;
    isLoading = true;
    notifyListeners();
    await _reload();
  }
  Future _reload() async {
    images = await _imageRepo.getByPurport(purport?.id);
    isLoading = false;
    notifyListeners();
  }

  // ----------- CRUD -------------

  Future add(String? path) async {
    if (path == null || purport == null) return;
    isLoading = true;
    notifyListeners();
    final newImage = PurImage.create(purportId: purport?.id ?? '', path: path, name: purport?.title ?? '');
    await _imageRepo.insert(newImage);
    await _reload();
  }

  Future deleteAllSelected() async {
    isLoading = true;
    isSelectionMode = false;
    notifyListeners();
    for (final id in selectedIds) {
      await _imageRepo.delete(id);
    }
    selectedIds = {};
    await _reload();
  }

  Future update(PurImage image) async {
    isLoading = true;
    notifyListeners();
    await _imageRepo.update(image);
    await _reload();
  }

  Future delete(String id) async {
    isLoading = true;
    notifyListeners();
    await _imageRepo.delete(id);
    await _reload();
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
    isLoading = true;
    notifyListeners();
    if (selectedIds.length == images.length) {
      selectedIds = {};
    } else {
      selectedIds = images.map((i) => i.id).toSet();
    }
    isLoading = false;
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
