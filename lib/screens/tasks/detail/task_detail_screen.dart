// lib/screens/tasks/task_details_screen.dart
import 'package:flutter/material.dart';
import 'package:life_game/models/enums/task_difficulty.dart';
import 'package:life_game/models/enums/task_priority.dart';
import 'package:life_game/models/task.dart';
import 'package:life_game/models/task_hierarchy.dart';
import 'package:life_game/screens/tasks/form/task_form_screen.dart';
import 'package:life_game/screens/tasks/list/task_list_model.dart';
import 'package:provider/provider.dart';

class TaskDetailsScreen extends StatefulWidget {
  final Task task;
  
  const TaskDetailsScreen({super.key, required this.task});

  @override
  State<TaskDetailsScreen> createState() => _TaskDetailsScreenState();
}

class _TaskDetailsScreenState extends State<TaskDetailsScreen> {
  final TaskHierarchyRepository _hierarchyRepo = TaskHierarchyRepository();
  final TaskRepository _taskRepo = TaskRepository();
  
  List<Task> _subtasks = [];
  bool _isLoading = true;
  
  @override
  void initState() {
    super.initState();
    _loadSubtasks();
  }
  
  Future<void> _loadSubtasks() async {
    setState(() => _isLoading = true);
    _subtasks = await _hierarchyRepo.getByParent(widget.task.id);
    setState(() => _isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.task.title),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () => _editTask(),
            tooltip: 'Редактировать',
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Информация о задаче
          _buildTaskInfo(context),
          
          // Разделитель
          const Divider(),
          
          // Заголовок подзадач
          _buildSubtasksHeader(),
          
          // Список подзадач
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _subtasks.isEmpty
                    ? _buildEmptySubtasks()
                    : ListView.builder(
                        itemCount: _subtasks.length,
                        itemBuilder: (context, index) {
                          return _buildSubtaskCard(_subtasks[index]);
                        },
                      ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _createSubtask,
        tooltip: 'Добавить подзадачу',
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildTaskInfo(BuildContext context) {
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
                  widget.task.title,
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                decoration: BoxDecoration(
                  color: widget.task.done
                      ? Colors.green.withValues(alpha: 0.2)
                      : Colors.orange.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  widget.task.done ? 'Выполнено' : 'В процессе',
                  style: TextStyle(
                    color: widget.task.done ? Colors.green : Colors.orange,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          
          // Описание
          if (widget.task.description.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Text(
                widget.task.description,
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
                label: widget.task.priority.displayName,
                color: widget.task.priority.color,
              ),
              _buildInfoChip(
                icon: Icons.speed,
                label: widget.task.difficulty.displayName,
                color: widget.task.difficulty.color,
              ),
              if (widget.task.datetime != null)
                _buildInfoChip(
                  icon: Icons.event,
                  label: '${widget.task.datetime!.day}.${widget.task.datetime!.month}.${widget.task.datetime!.year} ${widget.task.datetime!.hour}:${widget.task.datetime!.minute.toString().padLeft(2, '0')}',
                  color: widget.task.isOverdue && !widget.task.done
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

  Widget _buildSubtasksHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Подзадачи (${_subtasks.length})',
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

  Widget _buildEmptySubtasks() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.list_alt_outlined,
            size: 48,
            color: Theme.of(context).hintColor,
          ),
          const SizedBox(height: 16),
          Text(
            'Нет подзадач',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 8),
          Text(
            'Добавьте подзадачу, чтобы разбить основную на части',
            style: Theme.of(context).textTheme.bodySmall,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildSubtaskCard(Task subtask) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: ListTile(
        leading: Checkbox(
          value: subtask.done,
          onChanged: (_) => _toggleSubtaskDone(subtask),
        ),
        title: Text(
          subtask.title,
          style: TextStyle(
            decoration: subtask.done ? TextDecoration.lineThrough : null,
          ),
        ),
        subtitle: subtask.description.isNotEmpty
            ? Text(
                subtask.description,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.bodySmall,
              )
            : null,
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(Icons.edit, size: 18),
              onPressed: () => _editSubtask(subtask),
              tooltip: 'Редактировать',
            ),
            IconButton(
              icon: const Icon(Icons.delete_outline, size: 18),
              onPressed: () => _deleteSubtask(subtask),
              tooltip: 'Удалить',
            ),
          ],
        ),
        onTap: () {
          // Можно открыть детали подзадачи
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => TaskDetailsScreen(task: subtask),
            ),
          ).then((_) => _loadSubtasks());
        },
      ),
    );
  }

  Future<void> _toggleSubtaskDone(Task subtask) async {
    final updated = subtask.copyWith(done: !subtask.done);
    await _taskRepo.update(updated);
    await _loadSubtasks();
  }

  Future<void> _createSubtask() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const TaskFormScreen(),
      ),
    );
    
    if (result == true) {
      await _loadSubtasks();
    }
  }

  Future<void> _editSubtask(Task subtask) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => TaskFormScreen(task: subtask),
      ),
    );
    
    if (result == true) {
      await _loadSubtasks();
    }
  }

  Future<void> _deleteSubtask(Task subtask) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Удаление подзадачи'),
        content: Text('Вы уверены, что хотите удалить подзадачу "${subtask.title}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Отмена'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Удалить'),
          ),
        ],
      ),
    );
    
    if (confirm == true) {
      // Удаляем связь родитель-потомок
      final hierarchy = TaskHierarchy(
        parentId: widget.task.id,
        childId: subtask.id,
      );
      await _hierarchyRepo.deleteChildsBatch([hierarchy]);
      await _taskRepo.delete(subtask.id);
      await _loadSubtasks();
    }
  }

  void _editTask() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => TaskFormScreen(task: widget.task),
      ),
    ).then((_) {
      // Обновляем данные (родительская задача могла измениться)
      context.read<TaskListModel>().loadTasks();
      // Обновляем экран
      setState(() {});
    });
  }
}