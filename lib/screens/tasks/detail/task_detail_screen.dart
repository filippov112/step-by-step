import 'package:flutter/material.dart';
import 'package:life_game/models/enums/tag_type.dart';
import 'package:life_game/models/enums/task_difficulty.dart';
import 'package:life_game/models/enums/task_priority.dart';
import 'package:life_game/screens/tasks/form/task_form_screen.dart';
import 'package:life_game/screens/tasks/task_provider.dart';
import 'package:provider/provider.dart';
import 'package:life_game/models/task.dart';

class TaskDetailScreen extends StatefulWidget {
  final String taskId;
  
  const TaskDetailScreen({super.key, required this.taskId});

  @override
  State<TaskDetailScreen> createState() => _TaskDetailScreenState();
}

class _TaskDetailScreenState extends State<TaskDetailScreen> {
  Task? _task;
  List<Task> _subtasks = [];
  bool _isLoading = true;
  
  @override
  void initState() {
    super.initState();
    _loadData();
  }
  
  Future<void> _loadData() async {
    setState(() => _isLoading = true);
    
    final taskProvider = Provider.of<TaskProvider>(context, listen: false);
    _task = taskProvider.allTasks.firstWhere(
      (t) => t.id == widget.taskId,
    );
    
    if (_task != null) {
      _subtasks = await taskProvider.getSubtasks(widget.taskId);
    }
    
    setState(() => _isLoading = false);
  }
  
  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Детали задачи'),
          backgroundColor: Colors.deepPurple,
          foregroundColor: Colors.white,
        ),
        body: const Center(child: CircularProgressIndicator()),
      );
    }
    
    if (_task == null) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Детали задачи'),
          backgroundColor: Colors.deepPurple,
          foregroundColor: Colors.white,
        ),
        body: const Center(child: Text('Задача не найдена')),
      );
    }
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Детали задачи'),
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: _editTask,
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            flex: 2,
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: _buildTaskDetails(),
            ),
          ),
          const Divider(height: 1),
          Expanded(
            flex: 3,
            child: _buildSubtasksSection(),
          ),
        ],
      ),
    );
  }
  
  Widget _buildTaskDetails() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Заголовок и статус
        Row(
          children: [
            Expanded(
              child: Text(
                _task!.title,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: _task!.statusColor.withOpacity(0.2),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: _task!.statusColor.withOpacity(0.3)),
              ),
              child: Text(
                _task!.statusText,
                style: TextStyle(
                  color: _task!.statusColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        
        // Описание
        if (_task!.description.isNotEmpty) ...[
          const Text(
            'Описание:',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 4),
          Text(_task!.description),
          const SizedBox(height: 16),
        ],
        
        // Дата
        if (_task!.datetime != null) ...[
          const Text(
            'Запланировано:',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 4),
          Text(_task!.datetime!.toString()),
          const SizedBox(height: 16),
        ],
        
        // Приоритет и сложность
        Row(
          children: [
            _buildInfoChip(
              'Приоритет: ${_task!.priority.displayName}',
              _task!.priority.color,
            ),
            const SizedBox(width: 8),
            _buildInfoChip(
              'Сложность: ${_task!.difficulty.displayName}',
              _task!.difficulty.color,
            ),
          ],
        ),
        
        // Теги (упрощённо)
        const SizedBox(height: 16),
        const Text(
          'Теги:',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 4),
        Consumer<TaskProvider>(
          builder: (context, provider, child) {
            final tags = provider.getTaskTags(widget.taskId);
            if (tags.isEmpty) {
              return const Text('Нет тегов');
            }
            return Wrap(
              spacing: 8,
              children: tags.map((tag) {
                return Chip(
                  label: Text(tag.title),
                  backgroundColor: tag.type.color.withOpacity(0.2),
                  labelStyle: TextStyle(color: tag.type.color),
                );
              }).toList(),
            );
          },
        ),
        
        // Награды
        const SizedBox(height: 16),
        const Text(
          'Награды:',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 4),
        Consumer<TaskProvider>(
          builder: (context, provider, child) {
            final rewards = provider.getTaskRewards(widget.taskId);
            if (rewards.isEmpty) {
              return const Text('Нет наград');
            }
            return Column(
              children: rewards.map((reward) {
                return ListTile(
                  dense: true,
                  leading: const Icon(Icons.star, color: Colors.amber),
                  title: Text('Опыт: ${reward.experience}'),
                  subtitle: Text('Время: ${reward.time} мин'),
                );
              }).toList(),
            );
          },
        ),
      ],
    );
  }
  
  Widget _buildInfoChip(String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.2),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: color,
          fontSize: 12,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
  
  Widget _buildSubtasksSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              const Text(
                'Подзадачи',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const Spacer(),
              IconButton(
                icon: const Icon(Icons.add, color: Colors.deepPurple),
                onPressed: _addSubtask,
              ),
            ],
          ),
        ),
        Expanded(
          child: _subtasks.isEmpty
              ? const Center(
                  child: Text(
                    'Нет подзадач',
                    style: TextStyle(color: Colors.grey),
                  ),
                )
              : ListView.builder(
                  itemCount: _subtasks.length,
                  itemBuilder: (context, index) {
                    final subtask = _subtasks[index];
                    return _buildSubtaskTile(subtask);
                  },
                ),
        ),
      ],
    );
  }
  
  Widget _buildSubtaskTile(Task subtask) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: ListTile(
        leading: Checkbox(
          value: subtask.done,
          onChanged: (_) {
            context.read<TaskProvider>().toggleTaskStatus(subtask.id);
          },
          activeColor: Colors.deepPurple,
        ),
        title: Text(
          subtask.title,
          style: TextStyle(
            decoration: subtask.done ? TextDecoration.lineThrough : null,
            color: subtask.done ? Colors.grey : Colors.black87,
          ),
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(Icons.edit, size: 20),
              onPressed: () => _editSubtask(subtask),
            ),
            IconButton(
              icon: const Icon(Icons.delete, size: 20, color: Colors.red),
              onPressed: () => _deleteSubtask(subtask),
            ),
          ],
        ),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => TaskDetailScreen(taskId: subtask.id),
            ),
          );
        },
      ),
    );
  }
  
  void _editTask() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => TaskFormScreen(task: _task),
      ),
    ).then((_) {
      _loadData();
    });
  }
  
  void _addSubtask() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => TaskFormScreen(parentId: widget.taskId),
      ),
    ).then((_) {
      _loadData();
    });
  }
  
  void _editSubtask(Task subtask) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => TaskFormScreen(task: subtask),
      ),
    ).then((_) {
      _loadData();
    });
  }
  
  void _deleteSubtask(Task subtask) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Удалить подзадачу?'),
        content: const Text('Это действие нельзя отменить.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Отмена'),
          ),
          TextButton(
            onPressed: () {
              context.read<TaskProvider>().deleteSubtask(widget.taskId, subtask.id);
              _loadData();
              Navigator.pop(context);
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Удалить'),
          ),
        ],
      ),
    );
  }
}