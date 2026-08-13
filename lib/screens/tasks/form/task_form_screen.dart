// lib/screens/tasks/task_form_screen.dart
import 'package:flutter/material.dart';
import 'package:life_game/models/enums/task_difficulty.dart';
import 'package:life_game/models/enums/task_priority.dart';
import 'package:life_game/models/tag.dart';
import 'package:life_game/models/task.dart';
import 'package:life_game/screens/tasks/form/task_form_model.dart';
import 'package:life_game/themes/solo_leveling_theme.dart';
import 'package:life_game/widgets/common/entity_appbar.dart';
import 'package:life_game/widgets/common/tag_chip.dart';
import 'package:life_game/widgets/dialogs/select_date_time.dart';
import 'package:life_game/widgets/filters/tags_finder.dart';
import 'package:provider/provider.dart';

class TaskFormScreen extends StatefulWidget {
  final Task? task;
  final Task? parent;
  
  const TaskFormScreen({super.key, this.task, this.parent});

  @override
  State<TaskFormScreen> createState() => _TaskFormScreenState();
}

class _TaskFormScreenState extends State<TaskFormScreen> {
  final _formKey = GlobalKey<FormState>();
  late TaskFormModel model;
  
  @override
  void initState() {
    super.initState();
    model = context.read<TaskFormModel>();
    model.setTask(widget.task, widget.parent);
  }

  @override
  Widget build(BuildContext context) {
    var isEditing = context.select<TaskFormModel,bool>((model) => model.isEditing);
    var selectedDescription = context.select<TaskFormModel,String>((model) => model.selectedDescription);
    var selectedTitle = context.select<TaskFormModel,String>((model) => model.selectedTitle);
    var selectedDatetime = context.select<TaskFormModel,DateTime?>((model) => model.selectedDateTime);
    var selectedPriority = context.select<TaskFormModel,TaskPriority>((model) => model.selectedPriority);
    var selectedDifficulty = context.select<TaskFormModel,TaskDifficulty>((model) => model.selectedDifficulty);
    var selectedTags = context.select<TaskFormModel,List<Tag>>((model) => model.selectedTags);
    var selectedDone = context.select<TaskFormModel,bool>((model) => model.selectedDone);

    var setPriority = model.setPriority;
    var setDateTime = model.setDateTime;
    var setDifficulty = model.setDifficulty;
    var setSelectedTags = model.setSelectedTags;
    var setDescription = model.setDescription;
    var setTitle = model.setTitle;
    var setDone = model.setDone;
    var saveTask = model.saveTask;
    var deleteTask = model.deleteTask;

    return Scaffold(
      appBar: buildAppBar(
        'Задача',
        deleteCallback: () => _deleteTask(deleteTask),
      ),
      body: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(child: 
              ListView(
                padding: const EdgeInsets.all(16),
                children: [

                  Text(
                    'Основные поля',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  SizedBox(height: 12,),

                  // Название
                  TextFormField(
                    initialValue: selectedTitle,
                    onSaved: (val) => setTitle.call(val ?? ''),
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
                  const SizedBox(height: 12),

                  // Описание
                  TextFormField(
                    initialValue: selectedDescription,
                    onSaved: (val) => setDescription(val ?? ''),
                    decoration: const InputDecoration(
                      labelText: 'Описание',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.description),
                    ),
                    maxLines: 3,
                  ),
                  const SizedBox(height: 12), 
                  
                  // Дата и время
                  _buildDateTimePicker(selectedDatetime, setDateTime),

                  const SizedBox(height: 8,),
                  // Статус
                  _buildStatusSection(selectedDone, setDone),
                  
                  
                  const SizedBox(height: 8),
                  Divider(color:SoloLevelingTheme.steelBlue,),
                  const SizedBox(height: 8),
                  
                  // Приоритет
                  _buildPrioritySelector(selectedPriority, setPriority),
                  
                  const SizedBox(height: 8),
                  Divider(color:SoloLevelingTheme.steelBlue,),
                  const SizedBox(height: 8),
                  
                  // Сложность
                  _buildDifficultySelector(selectedDifficulty, setDifficulty),
                  
                  const SizedBox(height: 8),
                  Divider(color:SoloLevelingTheme.steelBlue,),
                  const SizedBox(height: 8),

                  // Теги
                  _buildTagsSection(selectedTags, setSelectedTags),
                  
                  const SizedBox(height: 8),
                ]
              ),   
            ),
            // Кнопки
            Padding(
              padding: EdgeInsetsGeometry.all(8), 
              child:  Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Отмена'),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () => _saveTask(saveTask),
                      child: Text(isEditing ? 'Сохранить' : 'Создать'),
                    ),
                  ),
                ],
              ),
            ),
          ]
        ),
      ),
    );
  }

  Widget _buildDateTimePicker(DateTime? currentDatetime, Function(DateTime?) setDateTime) {
    return Card(
      margin: EdgeInsets.all(0),
      child: ListTile(
        leading: const Icon(Icons.event),
        title: Text('Дата и время'),
        subtitle: Text(currentDatetime != null ?
          '${currentDatetime.day}.${currentDatetime.month}.${currentDatetime.year} '
          '${currentDatetime.hour}:${currentDatetime.minute.toString().padLeft(2, '0')}' : '',
        ),
        onTap: () async {
          final result = await selectDateTime(context, currentDatetime ?? DateTime.now());
          if (result != null) {
            setDateTime(result);
          }
        },
      ),
    );
  }

  Widget _buildPrioritySelector(TaskPriority currentPriority, Function(TaskPriority) setPriority) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Приоритет',
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: TaskPriority.values.map((priority) =>
            ChoiceChip(
              label: Text(priority.displayName),
              selected: currentPriority == priority,
              onSelected: (_) => setPriority(priority),
            ),
          ).toList(),
        ),
      ],
    );
  }

  Widget _buildDifficultySelector(TaskDifficulty currentDifficulty, Function(TaskDifficulty) setDifficulty) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Сложность',
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: TaskDifficulty.values.map((difficulty) =>
            ChoiceChip(
              label: Text(difficulty.displayName),
              selected: currentDifficulty == difficulty,
              onSelected: (_) => setDifficulty(difficulty),
           ),
          ).toList(),
        ),
      ],
    );
  }

  Widget _buildTagsSection(List<Tag> selectedTags, Function(List<Tag>) setSelectedTags) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Теги',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            TextButton.icon(
              onPressed: () => _openTagSelector(selectedTags, setSelectedTags),
              icon: const Icon(Icons.add, size: 16),
              label: const Text('Добавить тег'),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 4,
          runSpacing: 4,
          children: selectedTags.map((tag) =>
            TagChip(
              title: tag.title,
            ),
          ).toList(),
        ),
        if (selectedTags.isEmpty)
          Text(
            'Теги не добавлены',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: Theme.of(context).hintColor,
            ),
          ),
      ],
    );
  }

  Widget _buildStatusSection(bool selectedDone, Function(bool) setDone) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            
            Checkbox(value: selectedDone, onChanged: (val) => setDone(val ?? false)),
              
            Text('Выполнена')
          ],
        ),
      ],
    );
  }

  void _openTagSelector(List<Tag> selectedTags, Function(List<Tag>) setSelectedTags) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => TagsFinder(
        selectedTags: selectedTags,
        onConfirm: (tags) => setSelectedTags(tags),
      ),
    );
  }

  Future _saveTask(Future<bool> Function() saveTask) async {
    if (!_formKey.currentState!.validate()) return;
    _formKey.currentState?.save();
    var result = await saveTask(); 
    if (mounted) {
      Navigator.pop(context, result);
    }
  }

  Future _deleteTask(Future Function() deleteTask) async {
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
    
    if (confirm == true && context.mounted) {
      await deleteTask();
      if (context.mounted) {
        Navigator.pop(context);
      }
    }
  }
}