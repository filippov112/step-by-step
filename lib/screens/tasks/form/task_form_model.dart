import 'package:flutter/material.dart';
import 'package:life_game/models/enums/task_difficulty.dart';
import 'package:life_game/models/enums/task_priority.dart';
import 'package:life_game/models/skill.dart';
import 'package:life_game/models/tag.dart';
import 'package:life_game/models/tag_task.dart';
import 'package:life_game/models/task.dart';
import 'package:life_game/models/task_hierarchy.dart';
import 'package:life_game/models/task_reward.dart';

class TaskFormModel extends ChangeNotifier {

  // -------------- Fields ----------------
  late Task task;
  late String? parentId;
  final tagTaskRepo = TagTaskRepository();
  final rewardRepo = TaskRewardRepository();
  final skillRepo = SkillRepository();
  final taskRepo = TaskRepository();
  final tagRepo = TagRepository();
  final hierRepo = TaskHierarchyRepository();

  List<TagTask> _tagTasks = [];
  List<TaskReward> _rewards = [];
  List<Skill> allSkills = [];

  late String selectedTitle;
  late String selectedDescription;
  late DateTime? selectedDateTime;
  late TaskPriority selectedPriority;
  late TaskDifficulty selectedDifficulty;
  late bool selectedDone;

  List<Tag> selectedTags = [];
  List<TaskReward> selectedRewards = [];
  List<Skill> foundedSkills = [];

  late bool isEditing;

  // ---------------- Initialization ------------------

  void setTask(Task? t, Task? parent) {
    isEditing = t != null;
    parentId = parent?.id;
    task = t ?? Task.create(title: 'Новая задача');
    selectedDateTime = task.datetime ?? DateTime.now().add(const Duration(hours: 1));
    selectedPriority = task.priority;
    selectedDifficulty = task.difficulty;
    selectedTitle = task.title;
    selectedDescription = task.description;
    selectedDone = task.done;

    loadData();
  }

  Future loadData() async {
    await _loadTaskTags();
    await _loadRewards();
    await _loadSkills();
    notifyListeners();
  }

  Future _loadTaskTags() async {
    _tagTasks = (await tagTaskRepo.getAll()).where((tt) => tt.taskId == task.id).toList();
    final tags = <Tag>[];

    for (final tt in _tagTasks) {
      final tag = await tagRepo.get(tt.tagId);
      if (tag != null) {
        tags.add(tag);
      }
    }
    selectedTags = tags;
  }

  Future _loadRewards() async {
    _rewards = (await rewardRepo.getAll()).where((tt) => tt.taskId == task.id).toList();
    selectedRewards = _rewards.where((e) => true).toList();
  }

  Future _loadSkills() async {
    allSkills = await skillRepo.getAll();
  }

  // -------------------- Commands ------------------------

  void setTitle(String title) {
    selectedTitle = title;
    notifyListeners();
  }
  void setDescription(String description) {
    selectedDescription = description;
    notifyListeners();
  }
  void setDone(bool done) {
    selectedDone = done;
    notifyListeners();
  }
  void setDateTime(DateTime? datetime) {
    selectedDateTime = datetime;
    notifyListeners();
  }
  void setPriority(TaskPriority priority) {
    selectedPriority = priority;
    notifyListeners();
  }
  void setDifficulty(TaskDifficulty difficulty) {
    selectedDifficulty = difficulty;
    notifyListeners();
  }
  void setSelectedTags(List<Tag> tags) {
    selectedTags = tags;
    notifyListeners();
  }
  void setSelectedRewards(List<TaskReward> rewards) {
    selectedRewards = rewards;
    notifyListeners();
  }

  // ---------- Rewards ------------------

  Future searchSkills(String pattern) async {
    foundedSkills.clear();
    for (var skill in allSkills.where((skl) => skl.title.contains(pattern))) {
      foundedSkills.add(skill);
    }
    notifyListeners();
  }

  // ---------- CRUD ---------------------

  Future deleteTask() async {
    if (isEditing) {
      try {
        await taskRepo.delete(task.id);
      } catch (e) {
        print(e);
      }
    }
  }

  Future<bool> saveTask() async {
    task.title = selectedTitle;
    task.description = selectedDescription;
    task.datetime = selectedDateTime;
    task.done = selectedDone;
    task.priority = selectedPriority;
    task.difficulty = selectedDifficulty;
    try {
      if (isEditing) {
        await taskRepo.update(task);
      } else {
        await taskRepo.insert(task);
        if (parentId != null) {
          hierRepo.insertBatch([TaskHierarchy(parentId: parentId!, childId: task.id)]);
        }
      }
      await _saveTags();
      await _saveRewards();
    }
    catch (e) {
      print(e);
      return false;
    }
    return true;
  }

  Future _saveTags() async {
    final existingTagIds = _tagTasks.map((tt) => tt.tagId).toSet();
    final newTagIds = selectedTags.map((tag) => tag.id).toSet();
    final tagsToRemove = existingTagIds.difference(newTagIds);
    final tagsToAdd = newTagIds.difference(existingTagIds);

    for (final tagId in tagsToRemove) {
      await tagTaskRepo.delete(task.id, tagId);
    }
    for (final tagId in tagsToAdd) {
      final tagTask = TagTask.create(
        taskId: task.id,
        tagId: tagId,
      );
      await tagTaskRepo.insert(tagTask);
    }
  }

  Future _saveRewards() async {
    final existingRewardsId = _rewards.map((r) => r.id).toSet();
    final newRewardsId = selectedRewards.map((r) => r.id).toSet();
    final rewardsToRemove = existingRewardsId.difference(newRewardsId);
    final rewardsToAdd = newRewardsId.difference(existingRewardsId);
    final rewardsToUpdate = newRewardsId.difference(rewardsToAdd);

    for (final rewardId in rewardsToRemove) {
      await rewardRepo.delete(rewardId);
    }
    for (final rewardId in rewardsToAdd) {
      var reward = selectedRewards.firstWhere((r) => r.id == rewardId);
      reward.date = task.done ? task.datetime : null;
      await rewardRepo.insert(reward);
    }
    for (final rewardId in rewardsToUpdate) {
      var reward = selectedRewards.firstWhere((r) => r.id == rewardId);
      reward.date = task.done ? task.datetime : null;
      await rewardRepo.update(reward);
    }
  }
}