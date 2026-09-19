import 'dart:async';

import 'package:chaos_control/widgets/common/tree_list/tree_list_model.dart';
import 'package:chaos_control/widgets/common/tree_list/tree_record.dart';
import 'package:flutter/material.dart';
import 'package:chaos_control/models/purport.dart';

enum SortPurportField { title }

class PurportListModel extends ChangeNotifier {
  final PurportRepository _purRepo = PurportRepository();

  List<Purport> _purports = [];
  List<Purport> _filtered = [];
  List<TreeRecord<Purport>> purports = [];
  bool isLoading = false;

  final listModel = CustomTreeListModel<Purport>();

  // Состояние фильтрации
  String searchQuery = '';
  bool visibilitySearch = false;
  bool groupFilter = true;

  // Состояние сортировки
  SortPurportField sortField = SortPurportField.title;
  bool sortAscending = true;

  // Режим выделения
  bool isSelectionMode = false;
  Set<String> selectedIds = {};

  bool get hasActiveFilters {
    return searchQuery.isNotEmpty;
  }

  // Загрузка данных
  Future loadData() async {
    isLoading = true;
    notifyListeners();
    _purports = await _purRepo.getAll();
    await _applyFiltersAndSort();
  }

  List<TreeRecord<Purport>> _transformRecords() => _filtered
      .map(
        (e) => TreeRecord<Purport>(
          address: e.group,
          object: e,
          name: e.title,
          customIconData: e.icon,
        ),
      )
      .toList();

  Future openFolder(TreeRecord<Purport>? folder) async {
    isLoading = true;
    notifyListeners();
    purports = listModel.openFolder(list: _transformRecords(), folder: folder);
    isLoading = false;
    notifyListeners();
  }

  // Поиск
  Future setSearchQuery(String query) async {
    isLoading = true;
    notifyListeners();
    searchQuery = query;
    await _applyFiltersAndSort();
  }

  // Фильтры
  void setVisibilitySearch(bool value) {
    visibilitySearch = value;
    notifyListeners();
  }

  Future setGroupFilter(bool value) async {
    isLoading = true;
    notifyListeners();
    groupFilter = value;
    _applyFiltersAndSort();
  }

  void clearAllFilters() {
    isLoading = true;
    notifyListeners();
    searchQuery = '';
    _applyFiltersAndSort();
  }

  // Сортировка
  Future setSortField(SortPurportField field) async {
    if (sortField == field) {
      sortAscending = !sortAscending;
    } else {
      sortField = field;
      sortAscending = true;
    }
    isLoading = true;
    notifyListeners();
    await _applyFiltersAndSort();
  }

  // Основная логика фильтрации и сортировки
  Future _applyFiltersAndSort() async {
    var result = List<Purport>.from(_purports);
    // Поиск
    if (searchQuery.isNotEmpty) {
      final query = searchQuery.toLowerCase();
      result = result
          .where(
            (t) =>
                t.title.toLowerCase().contains(query) ||
                t.description.toLowerCase().contains(query),
          )
          .toList();
    }
    // Сортировка
    switch (sortField) {
      case SortPurportField.title:
        result.sort((a, b) => a.title.compareTo(b.title));
        break;
    }
    if (!sortAscending) {
      result = result.reversed.toList();
    }
    _filtered = result;
    purports = listModel.openFolder(
      list: _transformRecords(),
      folder: listModel.currentFolder,
      groupFilter: groupFilter,
    );
    isLoading = false;
    notifyListeners();
  }

  Future update(Purport cls) async {
    isLoading = true;
    notifyListeners();
    await _purRepo.update(cls);
    final index = _purports.indexWhere((t) => t.id == cls.id);
    if (index != -1) {
      _purports[index] = cls;
    }
    await _applyFiltersAndSort();
  }

  Future delete(String id) async {
    isLoading = true;
    notifyListeners();
    await _purRepo.delete(id);
    _purports.removeWhere((t) => t.id == id);
    selectedIds.remove(id);
    _applyFiltersAndSort();
  }

  Future deleteAllSelected() async {
    isLoading = true;
    isSelectionMode = false;
    notifyListeners();
    for (final id in selectedIds) {
      await _purRepo.delete(id);
      _purports.removeWhere((t) => t.id == id);
    }
    selectedIds.clear();
    await _applyFiltersAndSort();
  }

  // Режим выделения
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
    final set = _filtered
        .where(
          (t) =>
              t.group.startsWith('${listModel.currentAddress}/') ||
              t.group == listModel.currentAddress ||
              listModel.currentAddress.isEmpty,
        )
        .map((t) => t.id)
        .toSet();
    if (selectedIds.length == set.length) {
      selectedIds = {};
    } else {
      selectedIds = set;
    }
    isLoading = false;
    notifyListeners();
  }

  void toggleSelect(String id) {
    final selectedIdsCopy = selectedIds.toSet();
    if (selectedIdsCopy.contains(id)) {
      selectedIdsCopy.remove(id);
    } else {
      selectedIdsCopy.add(id);
    }
    selectedIds = selectedIdsCopy;
    notifyListeners();
  }

  void clearSelection() {
    selectedIds = {};
    isSelectionMode = false;
    notifyListeners();
  }

  Future moveItem(String id, String newAddress) async {
    final obj = _filtered.map((ob) => ob.id).contains(id)
        ? _filtered.firstWhere((el) => el.id == id)
        : null;
    if (obj == null) return;
    obj.group = newAddress;
    await _purRepo.update(obj);
  }

  Future moveAllTo(String newAddress, bool isSaveStructure) async {
    isLoading = true;
    notifyListeners();
    final listObjects = _filtered
        .where((el) => selectedIds.contains(el.id))
        .toList();
    Map<String, String> idAndGroups = {};
    for (var obj in listObjects) {
      idAndGroups[obj.id] = obj.group;
    }
    await listModel.moveAllTo(
      idAndGroups: idAndGroups,
      newAddress: newAddress,
      isSaveStructure: isSaveStructure,
      updateCallback: moveItem,
    );

    selectedIds.clear();
    isSelectionMode = false;
    await _applyFiltersAndSort();
  }
}
