import 'package:chaos_control/models/enums/wall_status.dart';
import 'package:chaos_control/tools/datetime.dart';
import 'package:flutter/material.dart';
import 'package:chaos_control/models/enums/wall_difficulty.dart';
import 'package:chaos_control/models/wall.dart';
import 'package:chaos_control/models/attempt.dart';

class TaskFormModel extends ChangeNotifier {

  // -------------- Fields ----------------
  Wall task = Wall.create(title: '', target: '');
  String? parentId;
  final _rewardRepo = AttemptRepository();
  final _taskRepo = WallRepository();

  List<Attempt> _rewards = [];

  String selectedTitle = '';
  String selectedDescription = '';
  WallDiff selectedDifficulty = WallDiff.F;
  WallStatus selectedStatus = WallStatus.breaking;

  List<Attempt> selectedRewards = [];

  bool isEditing = false;

  // ---------------- Initialization ------------------

  void setTask(Wall? t, Wall? parent) {
    isEditing = t != null;
    parentId = parent?.id;
    task = t ?? Wall.create(title: '', target: '');
    selectedDifficulty = task.difficulty;
    selectedTitle = task.title;
    selectedDescription = task.target;
    selectedStatus = task.status;
    notifyListeners();
    loadData();
  }

  Future loadData() async {
    await _loadRewards();
  }

  Future _loadRewards() async {
    _rewards = (await _rewardRepo.getAll()).where((tt) => tt.wallId == task.id).toList();
    selectedRewards = _rewards.where((e) => true).toList();
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
  void setStatus(bool done) {
    selectedStatus = done ? WallStatus.destroyed : WallStatus.breaking;
    notifyListeners();
  }
  void setDifficulty(WallDiff difficulty) {
    selectedDifficulty = difficulty;
    notifyListeners();
  }
  void setSelectedRewards(List<Attempt> rewards) {
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
    task.target = selectedDescription;
    task.status = selectedStatus;
    task.difficulty = selectedDifficulty;
    try {
      if (isEditing) {
        await _taskRepo.update(task);
      } else {
        await _taskRepo.insert(task);
      }
      await _saveRewards();
    }
    catch (e) {
      // print(e);
      return false;
    }
    return true;
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
      reward.date = DateTool.today();
      await _rewardRepo.insert(reward);
    }
    for (final rewardId in rewardsToUpdate) {
      var reward = selectedRewards.firstWhere((r) => r.id == rewardId);
      reward.date = DateTool.today();
      await _rewardRepo.update(reward);
    }
  }
}