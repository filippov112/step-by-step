import 'dart:io';

import 'package:flutter/material.dart';
import 'package:life_game/models/achievement.dart';
import 'package:life_game/models/enums/achiev_rar.dart';
import 'package:life_game/models/tag.dart';
import 'package:life_game/services/file_storage_service.dart';

class AchievementListModel extends ChangeNotifier {

  final AchievementRepository _repository = AchievementRepository();
  final TagRepository _tagRepository = TagRepository();
  final TagAchievementRepository _tagAchievementRepository = TagAchievementRepository();
  final FileStorageService _fileStorage = FileStorageService();

  List<Achievement> _allAchievements = [];
  List<Achievement> _filteredAchievements = [];
  List<TagAchievement> _allTagAchievements = [];
  List<Tag> _allTags = [];
  final List<Tag> _selectedTags = [];
  String _searchQuery = '';
  String? statusFilterValue;
  bool _showUnlockedOnly = false;
  bool _showLockedOnly = false;
  bool _isLoading = false;

  List<Achievement> get filteredAchievements => _filteredAchievements;
  List<Tag> get allTags => _allTags;
  List<Tag> get selectedTags => _selectedTags;
  String get searchQuery => _searchQuery;
  bool get showUnlockedOnly => _showUnlockedOnly;
  bool get showLockedOnly => _showLockedOnly;
  bool get isLoading => _isLoading;

  AchievementListModel() {
    loadData();
  }

  Future<void> loadData() async {
    _isLoading = true;
    notifyListeners();

    try {
      _allTags = await _tagRepository.getAll();
      _allAchievements = await _repository.getAll();
      _allTagAchievements = await _tagAchievementRepository.getAll();
      _applyFilters();
    } catch (e) {
      print('Ошибка загрузки данных: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void _applyFilters() {
    var result = List<Achievement>.from(_allAchievements);

    // Фильтр по поиску
    if (_searchQuery.isNotEmpty) {
      result = result.where((a) =>
        a.title.toLowerCase().contains(_searchQuery.toLowerCase()) ||
        a.description.toLowerCase().contains(_searchQuery.toLowerCase())
      ).toList();
    }

    // Фильтр по тегам
    if (_selectedTags.isNotEmpty) {
      var selectedAchId = _allTagAchievements.where((tagAch) =>
        _selectedTags.map((tag) => tag.id).contains(tagAch.tagId)
      ).map((tagAch) => tagAch.achievementId);

      result = result.where((a) => selectedAchId.contains(a.id)).toList();
    }

    // Фильтр по статусу получения
    if (_showUnlockedOnly) {
      result = result.where((a) => a.date != null).toList();
    } else if (_showLockedOnly) {
      result = result.where((a) => a.date == null).toList();
    }

    // Сортировка: сначала заблокированные, потом полученные
    result.sort((a, b) {
      if (a.date == null && b.date != null) return -1;
      if (a.date != null && b.date == null) return 1;
      return 0;
    });

    _filteredAchievements = result;
    notifyListeners();
  }

  void setSearchQuery(String query) {
    _searchQuery = query;
    _applyFilters();
  }

  void toggleTagFilter(Tag tag) {
    if (_selectedTags.contains(tag)) {
      _selectedTags.remove(tag);
    } else {
      _selectedTags.add(tag);
    }
    _applyFilters();
  }

  void clearTagFilters() {
    _selectedTags.clear();
    _applyFilters();
  }

  void toggleStatusFilter() {
    switch (statusFilterValue) {
      case null:
      case 'all':
        _toggleUnlockedFilter();
        if (_showUnlockedOnly) {
          _toggleUnlockedFilter();
        }
        break;
      case 'unlocked':
        _toggleUnlockedFilter();
        break;
      case 'locked':
        _toggleLockedFilter();
        break;
    }
  }

  void _toggleUnlockedFilter() {
    _showUnlockedOnly = !_showUnlockedOnly;
    if (_showUnlockedOnly) _showLockedOnly = false;
    _applyFilters();
  }

  void _toggleLockedFilter() {
    _showLockedOnly = !_showLockedOnly;
    if (_showLockedOnly) _showUnlockedOnly = false;
    _applyFilters();
  }

  Future<void> createAchievement({
    required String title,
    required String description,
    required AchievRar rarity,
    String? icon,
    List<Tag> tags = const [],
  }) async {
    _isLoading = true;
    notifyListeners();

    try {
      final achievement = Achievement.create(
        title: title,
        description: description,
        rarity: rarity,
        icon: icon,
      );

      await _repository.insert(achievement);

      // Сохраняем теги
      for (var tag in tags) {
        await _tagAchievementRepository.insert(
          TagAchievement.create(
            achievementId: achievement.id,
            tagId: tag.id,
          ),
        );
      }

      _allAchievements.add(achievement);
      _applyFilters();
    } catch (e) {
      print('Ошибка создания достижения: $e');
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> updateAchievement(Achievement achievement, {
    String? title,
    String? description,
    AchievRar? rarity,
    String? icon,
    List<Tag>? tags,
  }) async {
    _isLoading = true;
    notifyListeners();

    try {
      final updated = Achievement(
        id: achievement.id,
        title: title ?? achievement.title,
        description: description ?? achievement.description,
        rarity: rarity ?? achievement.rarity,
        date: achievement.date,
        icon: icon ?? achievement.icon,
      );

      await _repository.update(updated);

      // Обновляем теги
      if (tags != null) {
        // Удаляем старые связи
        final existingLinks = await _tagAchievementRepository.getAll();
        final toDelete = existingLinks.where((l) => l.achievementId == achievement.id);
        for (var link in toDelete) {
          await _tagAchievementRepository.delete(link.achievementId, link.tagId);
        }

        // Добавляем новые
        for (var tag in tags) {
          await _tagAchievementRepository.insert(
            TagAchievement.create(
              achievementId: achievement.id,
              tagId: tag.id,
            ),
          );
        }
      }

      final index = _allAchievements.indexWhere((a) => a.id == achievement.id);
      if (index != -1) {
        _allAchievements[index] = updated;
      }
      _applyFilters();
    } catch (e) {
      print('Ошибка обновления достижения: $e');
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> deleteAchievement(String id) async {
    _isLoading = true;
    notifyListeners();

    try {
      final achievement = _allAchievements.firstWhere((a) => a.id == id);
      
      // Удаляем иконку
      if (achievement.icon != null) {
        await _fileStorage.deleteOldFile(achievement.icon);
      }

      // Удаляем связи с тегами
      final links = await _tagAchievementRepository.getAll();
      final toDelete = links.where((l) => l.achievementId == id);
      for (var link in toDelete) {
        await _tagAchievementRepository.delete(link.achievementId, link.tagId);
      }

      await _repository.delete(id);
      _allAchievements.removeWhere((a) => a.id == id);
      _applyFilters();
    } catch (e) {
      print('Ошибка удаления достижения: $e');
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<String?> saveIcon(File imageFile) async {
    return await _fileStorage.saveAchievementIcon(imageFile);
  }

  Future<File?> pickIcon() async {
    return await _fileStorage.pickImageFromGallery();
  }

  // Получение тегов для достижения
  Future<List<Tag>> getTagsForAchievement(String achievementId) async {
    final links = await _tagAchievementRepository.getAll();
    final tagIds = links
        .where((l) => l.achievementId == achievementId)
        .map((l) => l.tagId)
        .toList();
    
    return _allTags.where((t) => tagIds.contains(t.id)).toList();
  }
}