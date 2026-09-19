import 'dart:async';

import 'package:chaos_control/models/enums/characteristics.dart';
import 'package:chaos_control/models/record.dart';
import 'package:chaos_control/services/datetool.dart';
import 'package:chaos_control/services/hours_calculator.dart';
import 'package:chaos_control/widgets/common/tree_list/tree_list_model.dart';
import 'package:chaos_control/widgets/common/tree_list/tree_record.dart';
import 'package:flutter/material.dart';

enum SortRecord { date, time }

enum TargetFilterType { all, targets, chronicles }

enum FavoriteFilterType { all, favorites, other }

extension TargetFilterTypeExt on TargetFilterType {
  String get displayName {
    switch (this) {
      case TargetFilterType.all:
        return 'Все записи';
      case TargetFilterType.targets:
        return 'Цели';
      case TargetFilterType.chronicles:
        return 'Хроники';
    }
  }
}

extension FavoriteFilterTypeExt on FavoriteFilterType {
  String get displayName {
    switch (this) {
      case FavoriteFilterType.all:
        return 'Все записи';
      case FavoriteFilterType.favorites:
        return 'Избранные';
      case FavoriteFilterType.other:
        return 'Прочие';
    }
  }
}

class RecordListModel extends ChangeNotifier {
  final HoursCalculator calculator;
  RecordListModel(this.calculator) {
    _recordRepo = RecordRepository(calculator);
  }
  late final RecordRepository _recordRepo;

  List<ChronicleRecord> _records = [];
  List<ChronicleRecord> _filtered = [];
  List<TreeRecord<ChronicleRecord>> records = [];
  bool isLoading = false;

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
  final defaulBeginDate = DateTool.today().subtract(Duration(days: 30));

  // Фильтрация
  String searchQuery = ''; // поиск
  bool visibilitySearch = false;
  // Период
  DateTime? dateBeginFilter = DateTool.today().subtract(Duration(days: 30));
  DateTime? dateEndFilter; 
  bool groupFilter = true; // группировка
  Characteristic? charFilter; // Хар-ка
  TargetFilterType targetFilter = TargetFilterType.all; // Цели
  FavoriteFilterType favoriteFilter = FavoriteFilterType.all; // Избранные

  // Сброс фильтров
  bool get hasActiveFilters {
    return dateBeginFilter != defaulBeginDate ||
        dateEndFilter != null ||
        charFilter != null ||
        targetFilter != TargetFilterType.all ||
        favoriteFilter != FavoriteFilterType.all ||
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
    isLoading = true;
    notifyListeners();
    _records = await _recordRepo.getAllByDate(
      startDate: DateTool.datetimeToDays(dateBeginFilter),
      endDate: DateTool.datetimeToDays(dateEndFilter),
    );
    await _applyFiltersAndSort();
  }

  void _reloadList() {
    records = listModel.openFolder(
      list: _transformRecords(),
      folder: listModel.currentFolder,
      groupFilter: groupFilter,
    );
  }

  List<TreeRecord<ChronicleRecord>> _transformRecords() =>
      _filtered.map(_buildTreeRecord).toList();
  TreeRecord<ChronicleRecord> _buildTreeRecord(ChronicleRecord record) {
    return TreeRecord<ChronicleRecord>(
      address: record.group,
      object: record,
      name: record.description,
    );
  }

  Future openFolder(TreeRecord<ChronicleRecord>? folder) async {
    isLoading = true;
    notifyListeners();
    records = listModel.openFolder(list: _transformRecords(), folder: folder);
    isLoading = false;
    notifyListeners();
  }

  // Поиск
  Future setSearchQuery(String query) async {
    isLoading = true;
    searchQuery = query;
    notifyListeners();
    await _applyFiltersAndSort();
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

  Future setCharFilter(Characteristic? value) async {
    charFilter = value;
    await loadData();
  }

  Future setGroupFilter(bool value) async {
    isLoading = true;
    notifyListeners();
    groupFilter = value;
    await _applyFiltersAndSort();
  }

  Future setTargetFilter(TargetFilterType value) async {
    isLoading = true;
    notifyListeners();
    targetFilter = value;
    await _applyFiltersAndSort();
  }

  Future setFavoriteFilter(FavoriteFilterType value) async {
    isLoading = true;
    notifyListeners();
    favoriteFilter = value;
    await _applyFiltersAndSort();
  }

  Future clearAllFilters() async {
    searchQuery = '';
    dateBeginFilter = defaulBeginDate;
    dateEndFilter = null;
    charFilter = null;
    targetFilter = TargetFilterType.all;
    favoriteFilter = FavoriteFilterType.all;
    await loadData();
  }

  // ------------- Сортировка -----------------

  Future setSorting(SortRecord field) async {
    isLoading = true;
    notifyListeners();
    if (sorting == field) {
      sortAscending = !sortAscending;
    } else {
      sorting = field;
      sortAscending = true;
    }
    await _applyFiltersAndSort();
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
    // Фильтр хар-ки
    if (charFilter != null) {
      result = result.where((t) => t.charTypes == charFilter).toList();
    }
    // Фильтр избранного
    if (favoriteFilter != FavoriteFilterType.all) {
      result = result
          .where(
            (t) =>
                t.favorite == (favoriteFilter == FavoriteFilterType.favorites),
          )
          .toList();
    }
    // Фильтр целей
    if (targetFilter != TargetFilterType.all) {
      result = result
          .where(
            (t) =>
                t.target ==
                (targetFilter == TargetFilterType.targets),
          )
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
    isLoading = false;
    notifyListeners();
  }

  static int dateAndTimeToInt(DateTime date, int time) {
    return (time - DateTool.timezone.inMilliseconds) % (1000 * 60 * 60 * 24) +
        date.millisecondsSinceEpoch;
  }

  Future update(ChronicleRecord trg) async {
    isLoading = true;
    notifyListeners();
    await _recordRepo.update(trg);
    final index = _records.indexWhere((t) => t.id == trg.id);
    if (index != -1) {
      _records[index] = trg;
    }
    await _applyFiltersAndSort();
  }

  Future delete(String id) async {
    isLoading = true;
    notifyListeners();
    await _recordRepo.delete(id);
    _records.removeWhere((t) => t.id == id);
    selectedIds.remove(id);
    await _applyFiltersAndSort();
  }

  Future deleteAllSelected() async {
    isLoading = true;
    isSelectionMode = false;
    notifyListeners();
    for (final id in selectedIds) {
      await _recordRepo.delete(id);
      _records.removeWhere((t) => t.id == id);
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

  Future moveItem(String id, String newAddress) async {
    final obj = _filtered.map((ob) => ob.id).contains(id)
        ? _filtered.firstWhere((el) => el.id == id)
        : null;
    if (obj == null) return;
    obj.group = newAddress;
    await _recordRepo.update(obj);
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
