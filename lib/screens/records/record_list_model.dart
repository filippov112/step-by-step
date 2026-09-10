import 'package:chaos_control/models/record.dart';
import 'package:chaos_control/widgets/common/tree_list/tree_list_model.dart';
import 'package:chaos_control/widgets/common/tree_list/tree_record.dart';
import 'package:flutter/material.dart';

enum SortRecord { date }

class RecordListModel extends ChangeNotifier {
  final _taskRepo = RecordRepository();

  List<Record> _records = [];
  List<Record> _filtered = [];
  List<TreeRecord<Record>> records = [];

  // Открытие / закрытие формы

  Record? currentRecord;
  bool visibilityForm = false;

  void openForm(Record? task) {
    visibilityForm = true;
    currentRecord = task;
    notifyListeners();
  }
  void closeForm() {
    visibilityForm = false;
    currentRecord = null;
    notifyListeners();
  }

  // ------

  final listModel = CustomTreeListModel<Record>();
  
  // Фильтрация
  String searchQuery = '';
  bool visibilitySearch = false;
  bool groupFilter = true;
  bool get hasActiveFilters {
    return searchQuery.isNotEmpty;
  }

  // Сортировка
  SortRecord sorting = SortRecord.date;
  bool sortAscending = true;
  
  // Выборки
  bool isSelectionMode = false;
  Set<String> selectedIds = {};
  
  
  // ---------- Загрузка данных ------------

  Future loadData() async {
    _records = await _taskRepo.getAll();
    await _applyFiltersAndSort();
    notifyListeners();
  }

  void _reloadList() {
    records = listModel.openFolder(
      list: transformRecords(), 
      folder: listModel.currentFolder,
      groupFilter: groupFilter
    );
  }

  List<TreeRecord<Record>> transformRecords() => _filtered.map(_buildTreeRecord).toList();
  TreeRecord<Record> _buildTreeRecord(Record record) {
    return TreeRecord<Record>(
      address: record.group,
      object: record,
      name: record.description,
    );
  }

  
  Future openFolder(TreeRecord<Record>? folder) async {
    records = listModel.openFolder(list: transformRecords(), folder: folder);
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

  Future setSorting(SortRecord field) async {
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
    var result = List<Record>.from(_records);
    // Поиск
    if (searchQuery.isNotEmpty) {
      final query = searchQuery.toLowerCase();
      result = result.where((t) =>
        t.description.toLowerCase().contains(query)
      ).toList();
    }
    // Сортировка
    switch (sorting) {
      case SortRecord.date:
        result.sort((a, b) => a.date.compareTo(b.date));
    }
    if (!sortAscending) {
      result = result.reversed.toList();
    }
    _filtered = result;
    _reloadList();
  }
  
  Future update(Record trg) async {
    await _taskRepo.update(trg);
    final index = _records.indexWhere((t) => t.id == trg.id);
    if (index != -1) {
      _records[index] = trg;
    }
    await _applyFiltersAndSort();
    notifyListeners();
  }

  Future delete(String id) async {
    await _taskRepo.delete(id);
    _records.removeWhere((t) => t.id == id);
    selectedIds.remove(id);
    await _applyFiltersAndSort();
    notifyListeners();
  }
  
  Future deleteAllSelected() async {
    for (final id in selectedIds) {
      await _taskRepo.delete(id);
      _records.removeWhere((t) => t.id == id);
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
