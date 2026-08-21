import 'package:flutter/material.dart';
import 'package:life_game/models/class.dart';
import 'package:life_game/models/enums/task_difficulty.dart';
import 'package:life_game/models/enums/task_priority.dart';
import 'package:life_game/models/skill.dart';
import 'package:life_game/models/tag.dart';
import 'package:life_game/models/task.dart';
import 'package:life_game/models/task_reward.dart';
import 'package:life_game/screens/tasks/form/task_form_model.dart';
import 'package:life_game/screens/tasks/form/widgets/buttons.dart';
import 'package:life_game/screens/tasks/form/widgets/rewards.dart';
import 'package:life_game/screens/tasks/form/widgets/tags.dart';
import 'package:life_game/screens/tasks/form/widgets/datetime.dart';
import 'package:life_game/screens/tasks/form/widgets/description.dart';
import 'package:life_game/screens/tasks/form/widgets/difficulty.dart';
import 'package:life_game/screens/tasks/form/widgets/priority.dart';
import 'package:life_game/screens/tasks/form/widgets/status.dart';
import 'package:life_game/screens/tasks/form/widgets/title.dart';
import 'package:life_game/widgets/common/confirm_dialog.dart';
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
  TextEditingController? titleController;
  TextEditingController? descController;

  @override
  void initState() {
    super.initState();
    model = context.read<TaskFormModel>();
    titleController = TextEditingController(text: widget.task?.title);
    descController = TextEditingController(text: widget.task?.description);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      model.setTask(widget.task, widget.parent);
    });
  }

  @override
  void dispose() {
    titleController?.dispose();
    descController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var taskId = context.select<TaskFormModel, String>(
      (model) => model.task.id,
    );
    var isEditing = context.select<TaskFormModel, bool>(
      (model) => model.isEditing,
    );
    var selectedDescription = context.select<TaskFormModel, String>(
      (model) => model.selectedDescription,
    );
    var selectedTitle = context.select<TaskFormModel, String>(
      (model) => model.selectedTitle,
    );
    var selectedDatetime = context.select<TaskFormModel, DateTime?>(
      (model) => model.selectedDateTime,
    );
    var selectedPriority = context.select<TaskFormModel, TaskPriority>(
      (model) => model.selectedPriority,
    );
    var selectedDifficulty = context.select<TaskFormModel, TaskDifficulty>(
      (model) => model.selectedDifficulty,
    );
    var selectedTags = context.select<TaskFormModel, List<Tag>>(
      (model) => model.selectedTags,
    );
    var selectedDone = context.select<TaskFormModel, bool>(
      (model) => model.selectedDone,
    );
    var skills = context.select<TaskFormModel, List<Skill>>(
      (model) => model.allSkills,
    );
    var classes = context.select<TaskFormModel, List<Class>>(
      (model) => model.allClasses,
    );
    var selectedRewards = context.select<TaskFormModel, List<TaskReward>>(
      (model) => model.selectedRewards,
    );

    var setPriority = model.setPriority;
    var setDateTime = model.setDateTime;
    var setDifficulty = model.setDifficulty;
    var setSelectedTags = model.setSelectedTags;
    var setSelectedRewards = model.setSelectedRewards;
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
            Expanded(
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  Text(
                    'Основные поля',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  SizedBox(height: 12),

                  // Название
                  buildTitleInput(controller: titleController),
                  const SizedBox(height: 12),

                  // Описание
                  buildDescriptionInput(controller: descController),
                  const SizedBox(height: 12),

                  // Дата и время
                  buildDateTimePicker(
                    context,
                    currentDatetime: selectedDatetime,
                    setDateTime: setDateTime,
                  ),

                  const SizedBox(height: 8),
                  // Статус
                  buildStatusSection(
                    selectedDone: selectedDone,
                    setDone: setDone,
                  ),

                  const SizedBox(height: 8),
                  const Divider(),
                  const SizedBox(height: 8),

                  // Приоритет
                  buildPrioritySelector(
                    context,
                    currentPriority: selectedPriority,
                    setPriority: setPriority,
                  ),

                  const SizedBox(height: 8),
                  const Divider(),
                  const SizedBox(height: 8),

                  // Сложность
                  buildDifficultySelector(
                    context,
                    currentDifficulty: selectedDifficulty,
                    setDifficulty: setDifficulty,
                  ),

                  const SizedBox(height: 8),
                  const Divider(),
                  const SizedBox(height: 8),

                  // Теги
                  buildTagsSection(
                    context,
                    selectedTags: selectedTags,
                    setSelectedTags: setSelectedTags,
                  ),

                  const SizedBox(height: 8),
                  const Divider(),
                  const SizedBox(height: 8),

                  // Награды
                  TaskRewardsSection(
                    selectedRewards: selectedRewards,
                    setSelectedRewards: setSelectedRewards,
                    skills: skills,
                    classes: classes,
                    taskId: taskId,
                  ),
                  const SizedBox(height: 8),
                ],
              ),
            ),
            // Кнопки
            buildButtonsBlock(
              context,
              saveCallback: () => _saveTask(saveTask),
              isEditing: isEditing,
            ),
          ],
        ),
      ),
    );
  }

  Future _saveTask(Future<bool> Function() saveTask) async {
    if (!mounted || _formKey.currentState == null) return;
    if (!(_formKey.currentState?.validate() ?? false)) return;

    model.setTitle(titleController?.text ?? '');
    model.setDescription(descController?.text ?? '');
    var result = await saveTask();
    if (mounted) {
      Navigator.pop(context, result);
    }
  }

  Future _deleteTask(Future Function() deleteTask) async {
    if (await showConfirmDialog(context) == true && context.mounted) {
      await deleteTask();
      if (context.mounted) {
        Navigator.pop(context);
      }
    }
  }
}
