import 'package:chaos_control/models/barrier.dart';
import 'package:chaos_control/widgets/common/tree_list/tree_list_model.dart';
import 'package:chaos_control/widgets/common/tree_list/tree_record.dart';
import 'package:flutter/material.dart';

enum SortBarrier { date }

class BarrierListModel extends ChangeNotifier {
  final _taskRepo = BarrierRepository();

  List<Barrier> _barriers = [];
  List<Barrier> _filtered = [];
  List<TreeRecord<Barrier>> barriers = [];

  // Открытие / закрытие формы

  Barrier? currentBarrier;
  bool visibilityForm = false;

  void openForm(Barrier? task) {
    visibilityForm = true;
    currentBarrier = task;
    notifyListeners();
  }
  void closeForm() {
    visibilityForm = false;
    currentBarrier = null;
    notifyListeners();
  }

  // ------

  final listModel = CustomTreeListModel<Barrier>();
  
  // Фильтрация
  String searchQuery = '';
  bool visibilitySearch = false;
  bool groupFilter = false;
  bool get hasActiveFilters {
    return searchQuery.isNotEmpty;
  }

  // Сортировка
  SortBarrier sorting = SortBarrier.date;
  bool sortAscending = true;
  
  // Выборки
  bool isSelectionMode = false;
  Set<String> selectedIds = {};
  
  
  // ---------- Загрузка данных ------------

  Future loadData() async {
    _barriers = await _taskRepo.getAll();
    await _applyFiltersAndSort();
    notifyListeners();
  }

  void _reloadList() {
    barriers = listModel.openFolder(
      list: transformRecords(), 
      folder: listModel.currentFolder,
      groupFilter: groupFilter
    );
  }

  List<TreeRecord<Barrier>> transformRecords() => _filtered.map(_buildTreeRecord).toList();
  TreeRecord<Barrier> _buildTreeRecord(Barrier barrier) {
    return TreeRecord<Barrier>(
      address: barrier.group,
      object: barrier,
      name: barrier.description,
    );
  }

  
  Future openFolder(TreeRecord<Barrier>? folder) async {
    barriers = listModel.openFolder(list: transformRecords(), folder: folder);
    notifyListeners();
  }
  
  // Поиск
  Future setSearchQuery(String query) async {
    searchQuery = query;
    await _applyFiltersAndSort();
    notifyListeners();
  }
  
  Future clearSearch() async {
    searchQuery = '';
    await _applyFiltersAndSort();
    notifyListeners();
  }
  
  // ---------- Фильтры -------------

  void setVisibilitySearch(bool value) {
    visibilitySearch = value;
    notifyListeners();
  }
  Future setGroupFilter(bool value) async {
    groupFilter = value;
    await _applyFiltersAndSort();
    notifyListeners();
  }
  Future clearAllFilters() async {
    searchQuery = '';
    await _applyFiltersAndSort();
    notifyListeners();
  }
  
  // ------------- Сортировка -----------------

  Future setSorting(SortBarrier field) async {
    if (sorting == field) {
      sortAscending = !sortAscending;
    } else {
      sorting = field;
      sortAscending = true;
    }
    await _applyFiltersAndSort();
    notifyListeners();
  }
  
  // Основная логика фильтрации и сортировки

  Future _applyFiltersAndSort() async {
    var result = List<Barrier>.from(_barriers);
    // Поиск
    if (searchQuery.isNotEmpty) {
      final query = searchQuery.toLowerCase();
      result = result.where((t) =>
        t.description.toLowerCase().contains(query)
      ).toList();
    }
    // Сортировка
    switch (sorting) {
      case SortBarrier.date:
        result.sort((a, b) => a.date.compareTo(b.date));
    }
    if (!sortAscending) {
      result = result.reversed.toList();
    }
    _filtered = result;
    _reloadList();
  }
  
  Future update(Barrier trg) async {
    await _taskRepo.update(trg);
    final index = _barriers.indexWhere((t) => t.id == trg.id);
    if (index != -1) {
      _barriers[index] = trg;
    }
    await _applyFiltersAndSort();
    notifyListeners();
  }

  Future delete(String id) async {
    await _taskRepo.delete(id);
    _barriers.removeWhere((t) => t.id == id);
    selectedIds.remove(id);
    await _applyFiltersAndSort();
    notifyListeners();
  }
  
  Future deleteAllSelected() async {
    for (final id in selectedIds) {
      await _taskRepo.delete(id);
      _barriers.removeWhere((t) => t.id == id);
    }
    selectedIds.clear();
    isSelectionMode = false;
    await _applyFiltersAndSort();
    notifyListeners();
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
    if (selectedIds.length == _filtered.length) {
      selectedIds = {};
    } else {
      selectedIds = _filtered.map((t) => t.id).toSet();
    }
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
}
