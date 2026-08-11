// import 'package:flutter/material.dart';
// import 'package:life_game/models/task.dart';
// import 'package:life_game/models/tag.dart';
// import 'package:life_game/models/reward.dart';
// import 'package:life_game/models/task_hierarchy.dart';

// class TaskProvider extends ChangeNotifier {
//   final TaskRepository _taskRepo = TaskRepository();
//   final TagTaskRepository _tagTaskRepo = TagTaskRepository();
//   final RewardRepository _rewardRepo = RewardRepository();
//   final TaskHierarchyRepository _hierarchyRepo = TaskHierarchyRepository();
  
//   List<Task> _tasks = [];
//   List<Task> _filteredTasks = [];
//   Map<String, List<Tag>> _taskTags = {};
//   Map<String, List<Reward>> _taskRewards = {};
//   Map<String, List<Task>> _subtasksCache = {};
  
//   String _searchQuery = '';
//   String _filterStatus = 'all'; // all, active, completed, overdue
//   String _sortBy = 'datetime'; // datetime, priority, difficulty, title
  
//   bool get isAscending => _sortDirectionAsc;
//   bool _sortDirectionAsc = true;
  
//   List<Task> get tasks => _filteredTasks;
//   List<Task> get allTasks => _tasks;
  
//   bool get isInitialized => _tasks.isNotEmpty;
  
//   TaskProvider() {
//     loadTasks();
//   }
  
//   // Загрузка всех задач
//   Future<void> loadTasks() async {
//     _tasks = await _taskRepo.getAll();
//     await _loadTagsAndRewards();
//     _applyFiltersAndSort();
//     notifyListeners();
//   }
  
//   // Загрузка тегов и наград для задач
//   Future<void> _loadTagsAndRewards() async {
//     final tagTasks = await _tagTaskRepo.getAll();
//     final rewards = await _rewardRepo.getAll();
    
//     _taskTags.clear();
//     _taskRewards.clear();
    
//     for (var task in _tasks) {
//       // Загружаем теги
//       final taskTagLinks = tagTasks.where((tt) => tt.taskId == task.id).toList();
//       // Здесь нужна загрузка самих тегов
//       // Упрощённо: пока оставим пустым
//       _taskTags[task.id] = [];
      
//       // Загружаем награды
//       _taskRewards[task.id] = rewards.where((r) => r.taskId == task.id).toList();
//     }
//   }
  
//   // Добавление задачи
//   Future<void> addTask(Task task, {List<String> tagIds = const [], List<Reward> rewards = const []}) async {
//     await _taskRepo.insert(task);
//     _tasks.add(task);
    
//     // Добавляем теги
//     for (var tagId in tagIds) {
//       await _tagTaskRepo.insert(TagTask(taskId: task.id, tagId: tagId));
//     }
    
//     // Добавляем награды
//     for (var reward in rewards) {
//       final newReward = reward.copyWith(taskId: task.id);
//       await _rewardRepo.insert(newReward);
//     }
    
//     await _loadTagsAndRewards();
//     _applyFiltersAndSort();
//     notifyListeners();
//   }
  
//   // Обновление задачи
//   Future<void> updateTask(Task task, {List<String> tagIds = const [], List<Reward> rewards = const []}) async {
//     await _taskRepo.update(task);
    
//     // Обновляем теги (удаляем старые, добавляем новые)
//     await _tagTaskRepo.deleteByTaskId(task.id);
//     for (var tagId in tagIds) {
//       await _tagTaskRepo.insert(TagTask(taskId: task.id, tagId: tagId));
//     }
    
//     // Обновляем награды (упрощённо: удаляем все и добавляем новые)
//     // В реальном проекте лучше делать diff
//     for (var reward in rewards) {
//       final newReward = reward.copyWith(taskId: task.id);
//       await _rewardRepo.insert(newReward);
//     }
    
//     // Обновляем задачу в списке
//     final index = _tasks.indexWhere((t) => t.id == task.id);
//     if (index != -1) {
//       _tasks[index] = task;
//     }
    
//     await _loadTagsAndRewards();
//     _applyFiltersAndSort();
//     notifyListeners();
//   }
  
//   // Удаление задачи
//   Future<void> deleteTask(String taskId) async {
//     await _taskRepo.delete(taskId);
//     _tasks.removeWhere((t) => t.id == taskId);
    
//     _applyFiltersAndSort();
//     notifyListeners();
//   }
  
//   // Переключение статуса выполнения
//   Future<void> toggleTaskStatus(String taskId) async {
//     final task = _tasks.firstWhere((t) => t.id == taskId);
//     final updatedTask = task.copyWith(done: !task.done);
//     await _taskRepo.update(updatedTask);
    
//     final index = _tasks.indexWhere((t) => t.id == taskId);
//     if (index != -1) {
//       _tasks[index] = updatedTask;
//     }
    
//     _applyFiltersAndSort();
//     notifyListeners();
//   }
  
//   // Получение подзадач
//   Future<List<Task>> getSubtasks(String parentId) async {
//     if (_subtasksCache.containsKey(parentId)) {
//       return _subtasksCache[parentId]!;
//     }
    
//     final subtasks = await _hierarchyRepo.getByParent(parentId);
//     _subtasksCache[parentId] = subtasks;
//     return subtasks;
//   }
  
//   // Добавление подзадачи
//   Future<void> addSubtask(String parentId, Task subtask) async {
//     await _taskRepo.insert(subtask);
//     _tasks.add(subtask);
    
//     final hierarchy = TaskHierarchy(parentId: parentId, childId: subtask.id);
//     await _hierarchyRepo.insertBatch([hierarchy]);
    
//     // Обновляем кэш
//     if (_subtasksCache.containsKey(parentId)) {
//       _subtasksCache[parentId]!.add(subtask);
//     }
    
//     _applyFiltersAndSort();
//     notifyListeners();
//   }
  
//   // Удаление подзадачи
//   Future<void> deleteSubtask(String parentId, String subtaskId) async {
//     await _taskRepo.delete(subtaskId);
//     _tasks.removeWhere((t) => t.id == subtaskId);
    
//     if (_subtasksCache.containsKey(parentId)) {
//       _subtasksCache[parentId]!.removeWhere((t) => t.id == subtaskId);
//     }
    
//     _applyFiltersAndSort();
//     notifyListeners();
//   }
  
//   // Получение тегов задачи
//   List<Tag> getTaskTags(String taskId) {
//     return _taskTags[taskId] ?? [];
//   }
  
//   // Получение наград задачи
//   List<Reward> getTaskRewards(String taskId) {
//     return _taskRewards[taskId] ?? [];
//   }
  
//   // Поиск
//   void setSearchQuery(String query) {
//     _searchQuery = query.toLowerCase().trim();
//     _applyFiltersAndSort();
//     notifyListeners();
//   }
  
//   // Фильтрация
//   void setFilter(String filter) {
//     _filterStatus = filter;
//     _applyFiltersAndSort();
//     notifyListeners();
//   }
  
//   // Сортировка
//   void setSortBy(String sortBy) {
//     if (_sortBy == sortBy) {
//       _sortDirectionAsc = !_sortDirectionAsc;
//     } else {
//       _sortBy = sortBy;
//       _sortDirectionAsc = true;
//     }
//     _applyFiltersAndSort();
//     notifyListeners();
//   }
  
//   void _applyFiltersAndSort() {
//     List<Task> result = List.from(_tasks);
    
//     // Поиск
//     if (_searchQuery.isNotEmpty) {
//       result = result.where((task) =>
//         task.title.toLowerCase().contains(_searchQuery) ||
//         task.description.toLowerCase().contains(_searchQuery)
//       ).toList();
//     }
    
//     // Фильтрация по статусу
//     switch (_filterStatus) {
//       case 'active':
//         result = result.where((task) => !task.done).toList();
//         break;
//       case 'completed':
//         result = result.where((task) => task.done).toList();
//         break;
//       case 'overdue':
//         result = result.where((task) => task.isOverdue).toList();
//         break;
//     }
    
//     // Сортировка
//     result.sort((a, b) {
//       int comparison = 0;
//       switch (_sortBy) {
//         case 'datetime':
//           comparison = (a.datetime?.millisecondsSinceEpoch ?? 0)
//               .compareTo(b.datetime?.millisecondsSinceEpoch ?? 0);
//           break;
//         case 'priority':
//           comparison = a.priority.index.compareTo(b.priority.index);
//           break;
//         case 'difficulty':
//           comparison = a.difficulty.index.compareTo(b.difficulty.index);
//           break;
//         case 'title':
//           comparison = a.title.compareTo(b.title);
//           break;
//       }
//       return _sortDirectionAsc ? comparison : -comparison;
//     });
    
//     _filteredTasks = result;
//   }
  
//   // Сброс всех фильтров
//   void resetFilters() {
//     _searchQuery = '';
//     _filterStatus = 'all';
//     _sortBy = 'datetime';
//     _sortDirectionAsc = true;
//     _applyFiltersAndSort();
//     notifyListeners();
//   }
// }