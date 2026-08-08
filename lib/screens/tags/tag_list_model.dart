import 'package:flutter/material.dart';
import 'package:life_game/models/enums/tag_type.dart';
import 'package:life_game/models/tag.dart';

class TagListModel extends ChangeNotifier {
  // late UserRepository provider = UserRepository();

  TagListModel();

  final TagRepository _repository = TagRepository();
  List<Tag> allTags = [];
  List<Tag> filteredTags = [];
  final Set<String> selectedIds = {};
  bool isSelectionMode = false;
  
  // Фильтры
  TagType? selectedTypeFilter;
  String searchQuery = '';

  bool shouldClearSearchController = false;
  bool get searchQueryisNotEmpty => searchQuery.isNotEmpty;

  Future loadTags() async {
    final tags = await _repository.getAll();
    allTags = tags;
    applyFilters();
  }

  Future insertTag(Tag tag) async {
    await _repository.insert(tag);
    loadTags();
  }
  Future updateTag(Tag tag) async {
    await _repository.update(tag);
    loadTags();
  }
  Future deleteTag(String id) async {
    await _repository.delete(id);
    selectedIds.remove(id);
    loadTags();
  }
  Future deleteSelected() async {
    for (final id in selectedIds) {
      await _repository.delete(id);
    }
    selectedIds.clear();
    isSelectionMode = false;
    loadTags();
  }

  void applyFilters() {
    
    filteredTags = allTags.where((tag) {
      // Фильтр по типу
      if (selectedTypeFilter != null && tag.type != selectedTypeFilter) {
        return false;
      }
      // Поиск по названию
      if (searchQuery.isNotEmpty) {
        return tag.title.toLowerCase().contains(searchQuery.toLowerCase());
      }
      return true;
    }).toList();
    // Сортировка по названию
    filteredTags.sort((a, b) => a.title.compareTo(b.title));
    notifyListeners();
  }


  void updateSearch(String query) {
    searchQuery = query;
    applyFilters();
  }

  void setTypeFilter(List<TagType> types) {
    selectedTypeFilter = types.length > 1 ? null : types.first;
    applyFilters();
  }

  void clearFilters() {
    selectedTypeFilter = null;
    searchQuery = '';
    shouldClearSearchController = true;
    applyFilters();
  }

  void toggleSelection(String id) {
    if (selectedIds.contains(id)) {
      selectedIds.remove(id);
    } else {
      selectedIds.add(id);
    }
    isSelectionMode = selectedIds.isNotEmpty;
    notifyListeners();
  }

  void selectAll() {
    if (selectedIds.length == filteredTags.length) {
      selectedIds.clear();
      isSelectionMode = false;
    } else {
      selectedIds.addAll(filteredTags.map((t) => t.id));
      isSelectionMode = true;
    }
    notifyListeners();
  }

  void clearSelection() {
    selectedIds.clear();
    isSelectionMode = false;
    notifyListeners();
  }

}