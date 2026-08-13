// lib/screens/tasks/task_details_screen.dart
import 'package:flutter/material.dart';
import 'package:life_game/models/enums/task_difficulty.dart';
import 'package:life_game/models/enums/task_priority.dart';
import 'package:life_game/models/tag.dart';
import 'package:life_game/models/task.dart';
import 'package:life_game/screens/tasks/detail/task_detail_model.dart';
import 'package:life_game/screens/tasks/detail/widgets/tile.dart';
import 'package:life_game/screens/tasks/form/task_form_screen.dart';
import 'package:life_game/widgets/common/empty_list_screen.dart';
import 'package:provider/provider.dart';

class TaskDetailsScreen extends StatefulWidget {
  final Task task;
  const TaskDetailsScreen({super.key, required this.task});

  @override
  State<TaskDetailsScreen> createState() => _TaskDetailsScreenState();
}

class _TaskDetailsScreenState extends State<TaskDetailsScreen> {

  late TaskDetailModel model;
  
  @override
  void initState() {
    super.initState();
    model = context.read<TaskDetailModel>();
    model.setLoading(true);
    model.setTask(widget.task);
  }
  
  Future<void> _loadSubtasks() async {
    model.setLoading(true);
    await model.loadSubtasks();
  }

  @override
  Widget build(BuildContext context) {

    var childrenCount = context.select<TaskDetailModel,Map<String,int>>((model) => model.childTasksCount);
    var childrenDoneCount = context.select<TaskDetailModel,Map<String,int>>((model) => model.childDoneTasksCount);
    var isLoading = context.select<TaskDetailModel,bool>((model) => model.isLoading);
    var subtasks = context.select<TaskDetailModel,List<Task>>((model) => model.subtasks);
    var task = context.select<TaskDetailModel,Task>((model) => model.task);

    var description = context.select<TaskDetailModel,String>((model) => model.task.description);
    var title = context.select<TaskDetailModel,String>((model) => model.task.title);
    var datetime = context.select<TaskDetailModel,DateTime?>((model) => model.task.datetime);
    var priority = context.select<TaskDetailModel,TaskPriority>((model) => model.task.priority);
    var difficulty = context.select<TaskDetailModel,TaskDifficulty>((model) => model.task.difficulty);
    var allTags = context.select<TaskDetailModel,List<Tag>>((model) => model.allTags);
    var done = context.select<TaskDetailModel,bool>((model) => model.task.done);
    var isOverdue = context.select<TaskDetailModel,bool>((model) => model.task.isOverdue);

    var setDone = model.setDone;
    var deleteTask = model.deleteTask;

    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () => _editTask(model, task),
            tooltip: 'Редактировать',
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Информация о задаче
          _buildTaskInfo(context, title, done, description, priority, difficulty, datetime, isOverdue),
          
          // Разделитель
          const Divider(),
          
          // Заголовок подзадач
          _buildSubtasksHeader(subtasks),
          
          // Список подзадач
          Expanded(
            child: isLoading
                ? const Center(child: CircularProgressIndicator())
                : subtasks.isEmpty
                    ? EmptyListScreen(
                      title: "Подзадач нет", 
                      subtitle: "Добавьте подзадачу, чтобы разбить основную на части", 
                      icon: Icons.task_alt_outlined
                      )
                    : ListView.builder(
                        itemCount: subtasks.length,
                        itemBuilder: (context, index) {
                          return DetailTaskCard(
                            model: model, 
                            task: subtasks[index], 
                            childrenCount: childrenCount[subtasks[index].id] ?? 0, 
                            childrenDoneCount: childrenDoneCount[subtasks[index].id] ?? 0
                          );
                        },
                      ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _createSubtask(task),
        tooltip: 'Добавить подзадачу',
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildTaskInfo(
    BuildContext context, 
    String title, 
    bool done, 
    String description, 
    TaskPriority priority,
    TaskDifficulty difficulty,
    DateTime? datetime,
    bool isOverdue) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Заголовок и статус
          Row(
            children: [
              Expanded(
                child: Text(
                  title,
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                decoration: BoxDecoration(
                  color: done
                      ? Colors.green.withValues(alpha: 0.2)
                      : Colors.orange.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  done ? 'Выполнено' : 'В процессе',
                  style: TextStyle(
                    color: done ? Colors.green : Colors.orange,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          
          // Описание
          if (description.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Text(
                description,
                style: Theme.of(context).textTheme.bodyLarge,
              ),
            ),
          
          // Детали
          Wrap(
            spacing: 8,
            runSpacing: 4,
            children: [
              _buildInfoChip(
                icon: Icons.priority_high,
                label: priority.displayName,
                color: priority.color,
              ),
              _buildInfoChip(
                icon: Icons.speed,
                label: difficulty.displayName,
                color: difficulty.color,
              ),
              if (datetime != null)
                _buildInfoChip(
                  icon: Icons.event,
                  label: '${datetime.day}.${datetime.month}.${datetime.year} ${datetime.hour}:${datetime.minute.toString().padLeft(2, '0')}',
                  color: isOverdue && !done
                      ? Colors.red
                      : null,
                ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInfoChip({
    required IconData icon,
    required String label,
    Color? color,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color?.withValues(alpha: 0.15) ?? Theme.of(context).dividerColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: color),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSubtasksHeader(List<Task> subtasks) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Подзадачи (${subtasks.length})',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadSubtasks,
            tooltip: 'Обновить',
          ),
        ],
      ),
    );
  }

  Future<void> _createSubtask(Task currentTask) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => TaskFormScreen(parent:currentTask),
      ),
    );
    
    if (result == true) {
      await _loadSubtasks();
    }
  }

  void _editTask(TaskDetailModel model, Task task) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => TaskFormScreen(task: task),
      ),
    ).then((_) async {
      if (context.mounted) {
        var checkExistTask = await model.checkExist();
        if (!checkExistTask && context.mounted) {
          Navigator.pop(context);
          return;
        }
        model.loadSubtasks();
      }
    });
  }
}