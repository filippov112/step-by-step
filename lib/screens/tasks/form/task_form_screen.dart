// lib/screens/tasks/task_form_screen.dart
import 'package:flutter/material.dart';
import 'package:life_game/models/enums/task_difficulty.dart';
import 'package:life_game/models/enums/task_priority.dart';
import 'package:life_game/models/tag.dart';
import 'package:life_game/models/task.dart';
import 'package:life_game/screens/tasks/list/task_list_model.dart';
import 'package:life_game/widgets/select_date_time.dart';
import 'package:life_game/widgets/tag_chip.dart';
import 'package:life_game/widgets/tag_selector_modal.dart';
import 'package:provider/provider.dart';

class TaskFormScreen extends StatefulWidget {
  final Task? task;
  
  const TaskFormScreen({super.key, this.task});

  @override
  State<TaskFormScreen> createState() => _TaskFormScreenState();
}

class _TaskFormScreenState extends State<TaskFormScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _titleController;
  late TextEditingController _descriptionController;
  late DateTime _selectedDateTime;
  late TaskPriority _selectedPriority;
  late TaskDifficulty _selectedDifficulty;
  late List<Tag> _selectedTags;
  late bool _isEditing;
  
  @override
  void initState() {
    super.initState();
    _isEditing = widget.task != null;
    _titleController = TextEditingController(text: widget.task?.title ?? '');
    _descriptionController = TextEditingController(text: widget.task?.description ?? '');
    _selectedDateTime = widget.task?.datetime ?? DateTime.now().add(const Duration(hours: 1));
    _selectedPriority = widget.task?.priority ?? TaskPriority.medium;
    _selectedDifficulty = widget.task?.difficulty ?? TaskDifficulty.medium;
    _selectedTags = [];
    
    // Загружаем теги, если редактируем
    if (_isEditing) {
      _loadTaskTags();
    }
  }

  Future<void> _loadTaskTags() async {
    final tagTaskRepo = TagTaskRepository();
    final tagRepo = TagRepository();
    
    // Получаем все связи тегов для этой задачи
    final allTagTasks = await tagTaskRepo.getAll();
    final taskTagTasks = allTagTasks.where((tt) => tt.taskId == widget.task!.id).toList();
    
    // Загружаем полные объекты тегов
    final tags = <Tag>[];
    for (final tt in taskTagTasks) {
      final tag = await tagRepo.get(tt.tagId);
      if (tag != null) {
        tags.add(tag);
      }
    }
    
    if (mounted) {
      setState(() {
        _selectedTags = tags;
      });
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_isEditing ? 'Редактирование задачи' : 'Новая задача'),
        actions: [
          if (_isEditing)
            IconButton(
              icon: const Icon(Icons.delete_outline),
              onPressed: _deleteTask,
              tooltip: 'Удалить',
            ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Название
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(
                  labelText: 'Название задачи',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.title),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Введите название задачи';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              
              // Описание
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(
                  labelText: 'Описание',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.description),
                ),
                maxLines: 3,
              ),
              const SizedBox(height: 16),
              
              // Дата и время
              _buildDateTimePicker(),
              const SizedBox(height: 16),
              
              // Приоритет
              _buildPrioritySelector(),
              const SizedBox(height: 16),
              
              // Сложность
              _buildDifficultySelector(),
              const SizedBox(height: 16),
              
              // Теги
              _buildTagsSection(),
              const SizedBox(height: 24),
              
              // Кнопки
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Отмена'),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _saveTask,
                      child: Text(_isEditing ? 'Сохранить' : 'Создать'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDateTimePicker() {
    return Card(
      child: ListTile(
        leading: const Icon(Icons.event),
        title: Text('Дата и время'),
        subtitle: Text(
          '${_selectedDateTime.day}.${_selectedDateTime.month}.${_selectedDateTime.year} '
          '${_selectedDateTime.hour}:${_selectedDateTime.minute.toString().padLeft(2, '0')}',
        ),
        onTap: () async {
          final result = await selectDateTime(context, _selectedDateTime);
          if (result != null) {
            setState(() {
              _selectedDateTime = result;
            });
          }
        },
      ),
    );
  }

  Widget _buildPrioritySelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Приоритет',
          style: Theme.of(context).textTheme.labelMedium,
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          children: TaskPriority.values.map((priority) =>
            ChoiceChip(
              label: Text(priority.displayName),
              selected: _selectedPriority == priority,
              onSelected: (_) => setState(() => _selectedPriority = priority),
              backgroundColor: Theme.of(context).cardColor,
              selectedColor: Theme.of(context).colorScheme.primaryContainer,
            ),
          ).toList(),
        ),
      ],
    );
  }

  Widget _buildDifficultySelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Сложность',
          style: Theme.of(context).textTheme.labelMedium,
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          children: TaskDifficulty.values.map((difficulty) =>
            ChoiceChip(
              label: Text(difficulty.displayName),
              selected: _selectedDifficulty == difficulty,
              onSelected: (_) => setState(() => _selectedDifficulty = difficulty),
              backgroundColor: Theme.of(context).cardColor,
              selectedColor: Theme.of(context).colorScheme.primaryContainer,
            ),
          ).toList(),
        ),
      ],
    );
  }

  Widget _buildTagsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Теги',
              style: Theme.of(context).textTheme.labelMedium,
            ),
            TextButton.icon(
              onPressed: _openTagSelector,
              icon: const Icon(Icons.add, size: 16),
              label: const Text('Добавить тег'),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 4,
          runSpacing: 4,
          children: _selectedTags.map((tag) =>
            TagChip(
              title: tag.title,
              callback: () {
                setState(() {
                  _selectedTags.remove(tag);
                });
              },
            ),
          ).toList(),
        ),
        if (_selectedTags.isEmpty)
          Text(
            'Теги не добавлены',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: Theme.of(context).hintColor,
            ),
          ),
      ],
    );
  }

  void _openTagSelector() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => TagSelectorModal(
        selectedTags: _selectedTags,
        onConfirm: (tags) {
          setState(() {
            _selectedTags = tags;
          });
        },
      ),
    );
  }

  void _saveTask() async {
    if (!_formKey.currentState!.validate()) return;
    
    final task = Task.create(
      title: _titleController.text,
      description: _descriptionController.text,
      datetime: _selectedDateTime,
      done: widget.task?.done ?? false,
      priority: _selectedPriority,
      difficulty: _selectedDifficulty,
    );
    
    final taskModel = context.read<TaskListModel>();
    
    String taskId;
    
    // Если редактирование - сохраняем ID
    if (_isEditing) {
      final updatedTask = task.copyWith(id: widget.task!.id);
      await taskModel.updateTask(updatedTask);
      taskId = widget.task!.id;
    } else {
      await taskModel.addTask(task);
      taskId = task.id;
    }
    
    // Сохраняем теги
    await _saveTags(taskId);
    
    if (mounted) {
      Navigator.pop(context, true);
    }
  }

  Future<void> _saveTags(String taskId) async {
    final tagTaskRepo = TagTaskRepository();
    
    // Получаем текущие теги задачи
    final allTagTasks = await tagTaskRepo.getAll();
    final existingTagTasks = allTagTasks.where((tt) => tt.taskId == taskId).toList();
    
    // Создаем множества для сравнения
    final existingTagIds = existingTagTasks.map((tt) => tt.tagId).toSet();
    final newTagIds = _selectedTags.map((tag) => tag.id).toSet();
    
    // Определяем теги для удаления (были, но теперь их нет)
    final tagsToRemove = existingTagIds.difference(newTagIds);
    
    // Определяем теги для добавления (появились новые)
    final tagsToAdd = newTagIds.difference(existingTagIds);
    
    // Удаляем теги
    for (final tagId in tagsToRemove) {
      await tagTaskRepo.delete(taskId, tagId);
    }
    
    // Добавляем теги
    for (final tagId in tagsToAdd) {
      final tagTask = TagTask.create(
        taskId: taskId,
        tagId: tagId,
      );
      await tagTaskRepo.insert(tagTask);
    }
  }

  void _deleteTask() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Удаление задачи'),
        content: const Text('Вы уверены, что хотите удалить эту задачу?'),
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
    
    if (confirm == true && widget.task != null && context.mounted) {
      context.read<TaskListModel>().deleteTask(widget.task!.id);
      Navigator.pop(context);
    }
  }
}