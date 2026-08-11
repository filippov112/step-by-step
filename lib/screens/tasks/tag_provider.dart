import 'package:flutter/material.dart';
import 'package:life_game/models/tag.dart';
import 'package:life_game/models/enums/tag_type.dart';

class TagProvider extends ChangeNotifier {
  final TagRepository _tagRepo = TagRepository();
  
  List<Tag> _tags = [];
  List<Tag> _filteredTags = [];
  
  String _searchQuery = '';
  TagType? _filterType;
  
  List<Tag> get tags => _filteredTags;
  List<Tag> get allTags => _tags;
  
  TagProvider() {
    loadTags();
  }
  
  Future<void> loadTags() async {
    _tags = await _tagRepo.getAll();
    _applyFilters();
    notifyListeners();
  }
  
  Future<void> addTag(Tag tag) async {
    await _tagRepo.insert(tag);
    _tags.add(tag);
    _applyFilters();
    notifyListeners();
  }
  
  Future<void> updateTag(Tag tag) async {
    await _tagRepo.update(tag);
    final index = _tags.indexWhere((t) => t.id == tag.id);
    if (index != -1) {
      _tags[index] = tag;
    }
    _applyFilters();
    notifyListeners();
  }
  
  Future<void> deleteTag(String tagId) async {
    await _tagRepo.delete(tagId);
    _tags.removeWhere((t) => t.id == tagId);
    _applyFilters();
    notifyListeners();
  }
  
  Tag? getTagById(String id) {
    return _tags.firstWhere((t) => t.id == id);
  }
  
  void setSearchQuery(String query) {
    _searchQuery = query.toLowerCase().trim();
    _applyFilters();
    notifyListeners();
  }
  
  void setFilterType(TagType? type) {
    _filterType = type;
    _applyFilters();
    notifyListeners();
  }
  
  void _applyFilters() {
    _filteredTags = List.from(_tags);
    
    if (_searchQuery.isNotEmpty) {
      _filteredTags = _filteredTags.where((tag) =>
        tag.title.toLowerCase().contains(_searchQuery)
      ).toList();
    }
    
    if (_filterType != null) {
      _filteredTags = _filteredTags.where((tag) =>
        tag.type == _filterType
      ).toList();
    }
  }
  
  List<Tag> getTagsByType(TagType type) {
    return _tags.where((tag) => tag.type == type).toList();
  }
}