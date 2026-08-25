import 'package:flutter/material.dart';
import 'package:chaos_control/models/class.dart';
import 'package:chaos_control/models/enums/task_difficulty.dart';
import 'package:chaos_control/models/enums/task_priority.dart';
import 'package:chaos_control/models/skill.dart';
import 'package:chaos_control/models/tag.dart';
import 'package:chaos_control/models/tag_task.dart';
import 'package:chaos_control/models/task.dart';
import 'package:chaos_control/models/task_hierarchy.dart';
import 'package:chaos_control/models/task_reward.dart';

class TaskFormModel extends ChangeNotifier {

  // -------------- Fields ----------------
  Task task = Task.create(title: '', description: '');
  String? parentId;
  final _tagTaskRepo = TagTaskRepository();
  final _rewardRepo = TaskRewardRepository();
  final _skillRepo = SkillRepository();
  final _classRepo = ClassRepository();
  final _taskRepo = TaskRepository();
  final _tagRepo = TagRepository();
  final _hierRepo = TaskHierarchyRepository();

  List<TagTask> _tagTasks = [];
  List<TaskReward> _rewards = [];
  List<Skill> allSkills = [];
  List<Class> allClasses = [];

  String selectedTitle = '';
  String selectedDescription = '';
  DateTime? selectedDateTime;
  TaskPriority selectedPriority = TaskPriority.medium;
  TaskDifficulty selectedDifficulty = TaskDifficulty.medium;
  bool selectedDone = false;

  List<Tag> selectedTags = [];
  List<TaskReward> selectedRewards = [];
  List<Skill> foundedSkills = [];

  bool isEditing = false;

  // ---------------- Initialization ------------------

  void setTask(Task? t, Task? parent) {
    isEditing = t != null;
    parentId = parent?.id;
    task = t ?? Task.create(title: '', description: '');
    selectedDateTime = task.datetime;
    selectedPriority = task.priority;
    selectedDifficulty = task.difficulty;
    selectedTitle = task.title;
    selectedDescription = task.description;
    selectedDone = task.done;
    notifyListeners();
    loadData();
  }

  Future loadData() async {
    await _loadTaskTags();
    await _loadRewards();
    await _loadSkills();
    await _loadClasses();
  }

  Future _loadTaskTags() async {
    _tagTasks = (await _tagTaskRepo.getAll()).where((tt) => tt.taskId == task.id).toList();
    final tags = <Tag>[];

    for (final tt in _tagTasks) {
      final tag = await _tagRepo.get(tt.tagId);
      if (tag != null) {
        tags.add(tag);
      }
    }
    selectedTags = tags;
    notifyListeners();
  }

  Future _loadRewards() async {
    _rewards = (await _rewardRepo.getAll()).where((tt) => tt.taskId == task.id).toList();
    selectedRewards = _rewards.where((e) => true).toList();
    notifyListeners();
  }

  Future _loadSkills() async {
    allSkills = await _skillRepo.getAll();
    notifyListeners();
  }
  Future _loadClasses() async {
    allClasses = await _classRepo.getAll();
    notifyListeners();
  }

  // -------------------- Commands ------------------------

  void setTitle(String? title) {
    selectedTitle = title ?? '';
    notifyListeners();
  }
  void setDescription(String? description) {
    selectedDescription = description ?? '';
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

  // ---------- CRUD ---------------------

  Future deleteTask() async {
    if (isEditing) {
      try {
        await _taskRepo.delete(task.id);
      } catch (e) {
        // print(e);
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
        await _taskRepo.update(task);
      } else {
        await _taskRepo.insert(task);
        if (parentId != null) {
          await _hierRepo.insertBatch([TaskHierarchy(parentId: parentId!, childId: task.id)]);
        }
      }
      await _saveTags();
      await _saveRewards();
    }
    catch (e) {
      // print(e);
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
      await _tagTaskRepo.delete(task.id, tagId);
    }
    for (final tagId in tagsToAdd) {
      final tagTask = TagTask.create(
        taskId: task.id,
        tagId: tagId,
      );
      await _tagTaskRepo.insert(tagTask);
    }
  }

  Future _saveRewards() async {
    final existingRewardsId = _rewards.map((r) => r.id).toSet();
    final newRewardsId = selectedRewards.map((r) => r.id).toSet();
    final rewardsToRemove = existingRewardsId.difference(newRewardsId);
    final rewardsToAdd = newRewardsId.difference(existingRewardsId);
    final rewardsToUpdate = newRewardsId.difference(rewardsToAdd);

    for (final rewardId in rewardsToRemove) {
      await _rewardRepo.delete(rewardId);
    }
    for (final rewardId in rewardsToAdd) {
      var reward = selectedRewards.firstWhere((r) => r.id == rewardId);
      reward.date = task.done ? task.datetime : null;
      await _rewardRepo.insert(reward);
    }
    for (final rewardId in rewardsToUpdate) {
      var reward = selectedRewards.firstWhere((r) => r.id == rewardId);
      reward.date = task.done ? task.datetime : null;
      await _rewardRepo.update(reward);
    }
  }
}