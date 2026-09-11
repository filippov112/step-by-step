import 'package:chaos_control/models/record.dart';
import 'package:chaos_control/services/datetool.dart';
import 'package:chaos_control/widgets/common/tree_list/tree_list_model.dart';
import 'package:chaos_control/widgets/common/tree_list/tree_record.dart';
import 'package:flutter/material.dart';

enum SortRecord { date, time }

class RecordListModel extends ChangeNotifier {
  final _taskRepo = RecordRepository();

  List<ChronicleRecord> _records = [];
  List<ChronicleRecord> _filtered = [];
  List<TreeRecord<ChronicleRecord>> records = [];

  // Открытие / закрытие формы
  bool visibilityForm = false;

  void openForm(ChronicleRecord? task) {
    visibilityForm = true;
    notifyListeners();
  }

  void closeForm() {
    visibilityForm = false;
    notifyListeners();
  }

  // ------

  final listModel = CustomTreeListModel<ChronicleRecord>();

  // Фильтрация
  String searchQuery = '';
  DateTime? dateBeginFilter, dateEndFilter;
  bool visibilitySearch = false;
  bool groupFilter = true;
  bool get hasActiveFilters {
    return dateBeginFilter != null ||
        dateEndFilter != null ||
        searchQuery.isNotEmpty;
  }

  // Сортировка
  SortRecord sorting = SortRecord.date;
  bool sortAscending = true;

  // Выборки
  bool isSelectionMode = false;
  Set<String> selectedIds = {};

  // ---------- Загрузка данных ------------

  Future loadData() async {
    _records = await _taskRepo.getAllByDate(
      startDate: DateTool.datetimeToDays(dateBeginFilter),
      endDate: DateTool.datetimeToDays(dateEndFilter),
    );
    await _applyFiltersAndSort();
    notifyListeners();
  }

  void _reloadList() {
    records = listModel.openFolder(
      list: transformRecords(),
      folder: listModel.currentFolder,
      groupFilter: groupFilter,
    );
  }

  List<TreeRecord<ChronicleRecord>> transformRecords() =>
      _filtered.map(_buildTreeRecord).toList();
  TreeRecord<ChronicleRecord> _buildTreeRecord(ChronicleRecord record) {
    return TreeRecord<ChronicleRecord>(
      address: record.group,
      object: record,
      name: record.description,
    );
  }

  Future openFolder(TreeRecord<ChronicleRecord>? folder) async {
    records = listModel.openFolder(list: transformRecords(), folder: folder);
    notifyListeners();
  }

  // Поиск
  Future setSearchQuery(String query) async {
    searchQuery = query;
    await _applyFiltersAndSort();
    notifyListeners();
  }

  // ---------- Фильтры -------------

  void setVisibilitySearch(bool value) {
    visibilitySearch = value;
    notifyListeners();
  }

  Future setDateBeginFilter(DateTime? value) async {
    dateBeginFilter = value;
    await loadData();
  }

  Future setDateEndFilter(DateTime? value) async {
    dateEndFilter = value;
    await loadData();
  }

  Future setGroupFilter(bool value) async {
    groupFilter = value;
    await _applyFiltersAndSort();
    notifyListeners();
  }

  Future clearAllFilters() async {
    searchQuery = '';
    dateBeginFilter = null;
    dateEndFilter = null;
    await loadData();
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
    var result = List<ChronicleRecord>.from(_records);
    // Поиск
    if (searchQuery.isNotEmpty) {
      final query = searchQuery.toLowerCase();
      result = result
          .where((t) => t.description.toLowerCase().contains(query))
          .toList();
    }
    // Сортировка
    switch (sorting) {
      case SortRecord.date:
        result.sort(
          (a, b) => dateAndTimeToInt(
            a.date,
            a.time,
          ).compareTo(dateAndTimeToInt(b.date, b.time)),
        );
      case SortRecord.time:
        result.sort((a, b) => a.time.compareTo(b.time));
    }
    if (!sortAscending) {
      result = result.reversed.toList();
    }
    _filtered = result;
    _reloadList();
  }

  static int dateAndTimeToInt(DateTime date, int time) {
    return (time - DateTool.timezone.inMilliseconds) % (1000 * 60 * 60 * 24) +
        date.millisecondsSinceEpoch;
  }

  Future update(ChronicleRecord trg) async {
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
    final set = _filtered.where((t) => t.group.startsWith(listModel.currentAddress) ).map((t) => t.id).toSet();
    if (selectedIds.length == set.length) {
      selectedIds = {};
    } else {
      selectedIds = set;
    }
    notifyListeners();
  }

  void toggleSelect(String id) {
    if (visibilityForm) {
      visibilityForm = false;
    }
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
