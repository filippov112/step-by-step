import 'package:chaos_control/models/pur_sound.dart';
import 'package:chaos_control/models/purport.dart';
import 'package:flutter/material.dart';

class PurportSoundsModel extends ChangeNotifier {
  final _soundRepo = PurSoundRepository();
  Purport? purport;
  List<PurSound> sounds = [];

  bool isSelectionMode = false;
  Set<String> selectedIds = {};

  // ---------- INIT ---------------
  
  Future init(Purport pur) async {
    purport = pur;
    await _reload();
  }
  Future _reload() async {
    sounds = await _soundRepo.getByPurport(purport?.id);
  }

  // ----------- CRUD -------------

  Future add(String? title, String? path) async {
    if (path == null || purport == null) return;
    final newImage = PurSound.create(purportId: purport?.id ?? '', path: path, title: title ?? '');
    await _soundRepo.insert(newImage);
    _reload();
    notifyListeners();
  }

  Future deleteAllSelected() async {
    for (final id in selectedIds) {
      await _soundRepo.delete(id);
    }
    selectedIds = {};
    isSelectionMode = false;
    await _reload();
    notifyListeners();
  }

  Future update(PurSound image) async {
    await _soundRepo.update(image);
    await _reload();
    notifyListeners();
  }

  Future delete(String id) async {
    await _soundRepo.delete(id);
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
    if (selectedIds.length == sounds.length) {
      selectedIds = {};
    } else {
      selectedIds = sounds.map((i) => i.id).toSet();
    }
    notifyListeners();
  }

  void toggleSelect(String id) {
    if (!isSelectionMode) toggleSelectionMode();
    final selectedsoundsCopy = selectedIds.toSet();
    if (selectedsoundsCopy.contains(id)) {
      selectedsoundsCopy.remove(id);
    } else {
      selectedsoundsCopy.add(id);
    }
    selectedIds = selectedsoundsCopy;
    notifyListeners();
  }

  void clearSelection() {
    selectedIds = {};
    isSelectionMode = false;
    notifyListeners();
  }
}
