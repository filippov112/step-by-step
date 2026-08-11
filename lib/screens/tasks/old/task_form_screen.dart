// import 'package:flutter/material.dart';
// import 'package:life_game/screens/tasks/list/old/tag_provider.dart';
// import 'package:life_game/screens/tasks/list/old/task_provider.dart';
// import 'package:provider/provider.dart';
// import 'package:life_game/models/task.dart';
// import 'package:life_game/models/tag.dart';
// import 'package:life_game/models/reward.dart';
// import 'package:life_game/models/enums/task_priority.dart';
// import 'package:life_game/models/enums/task_difficulty.dart';
// import 'package:life_game/models/enums/tag_type.dart';

// class TaskFormScreen extends StatefulWidget {
//   final Task? task;
//   final String? parentId;
  
//   const TaskFormScreen({super.key, this.task, this.parentId});

//   @override
//   State<TaskFormScreen> createState() => _TaskFormScreenState();
// }

// class _TaskFormScreenState extends State<TaskFormScreen> {
//   final _formKey = GlobalKey<FormState>();
  
//   late TextEditingController _titleController;
//   late TextEditingController _descriptionController;
//   late DateTime? _selectedDate;
//   late TimeOfDay? _selectedTime;
//   late bool _isDone;
//   late TaskPriority _selectedPriority;
//   late TaskDifficulty _selectedDifficulty;
  
//   List<Tag> _selectedTags = [];
//   List<Reward> _rewards = [];
  
//   @override
//   void initState() {
//     super.initState();
    
//     _titleController = TextEditingController(text: widget.task?.title ?? '');
//     _descriptionController = TextEditingController(text: widget.task?.description ?? '');
//     _selectedDate = widget.task?.datetime ?? DateTime.now();
//     _selectedTime = TimeOfDay.fromDateTime(widget.task?.datetime ?? DateTime.now());
//     _isDone = widget.task?.done ?? false;
//     _selectedPriority = widget.task?.priority ?? TaskPriority.medium;
//     _selectedDifficulty = widget.task?.difficulty ?? TaskDifficulty.medium;
    
//     // Загружаем теги, если редактируем
//     if (widget.task != null) {
//       final taskProvider = Provider.of<TaskProvider>(context, listen: false);
//       _selectedTags = taskProvider.getTaskTags(widget.task!.id);
//     }
//   }
  
//   @override
//   void dispose() {
//     _titleController.dispose();
//     _descriptionController.dispose();
//     super.dispose();
//   }
  
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(widget.task == null ? 'Создание задачи' : 'Редактирование задачи'),
//         backgroundColor: Colors.deepPurple,
//         foregroundColor: Colors.white,
//         actions: [
//           if (widget.task != null)
//             IconButton(
//               icon: const Icon(Icons.delete),
//               onPressed: _confirmDelete,
//             ),
//         ],
//       ),
//       body: Form(
//         key: _formKey,
//         child: SingleChildScrollView(
//           padding: const EdgeInsets.all(16),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               // Название
//               TextFormField(
//                 controller: _titleController,
//                 decoration: const InputDecoration(
//                   labelText: 'Название задачи *',
//                   border: OutlineInputBorder(),
//                 ),
//                 validator: (value) {
//                   if (value == null || value.isEmpty) {
//                     return 'Введите название задачи';
//                   }
//                   return null;
//                 },
//               ),
//               const SizedBox(height: 16),
              
//               // Описание
//               TextFormField(
//                 controller: _descriptionController,
//                 decoration: const InputDecoration(
//                   labelText: 'Описание',
//                   border: OutlineInputBorder(),
//                 ),
//                 maxLines: 3,
//               ),
//               const SizedBox(height: 16),
              
//               // Дата и время
//               Row(
//                 children: [
//                   Expanded(
//                     child: InkWell(
//                       onTap: _selectDate,
//                       child: InputDecorator(
//                         decoration: const InputDecoration(
//                           labelText: 'Дата',
//                           border: OutlineInputBorder(),
//                         ),
//                         child: Text(
//                           _selectedDate != null
//                               ? '${_selectedDate!.day}.${_selectedDate!.month}.${_selectedDate!.year}'
//                               : 'Выберите дату',
//                         ),
//                       ),
//                     ),
//                   ),
//                   const SizedBox(width: 16),
//                   Expanded(
//                     child: InkWell(
//                       onTap: _selectTime,
//                       child: InputDecorator(
//                         decoration: const InputDecoration(
//                           labelText: 'Время',
//                           border: OutlineInputBorder(),
//                         ),
//                         child: Text(
//                           _selectedTime != null
//                               ? _selectedTime!.format(context)
//                               : 'Выберите время',
//                         ),
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//               const SizedBox(height: 16),
              
//               // Приоритет и сложность
//               Row(
//                 children: [
//                   Expanded(
//                     child: DropdownButtonFormField<TaskPriority>(
//                       value: _selectedPriority,
//                       decoration: const InputDecoration(
//                         labelText: 'Приоритет',
//                         border: OutlineInputBorder(),
//                       ),
//                       items: allTaskPriorities.map((priority) {
//                         return DropdownMenuItem(
//                           value: priority,
//                           child: Row(
//                             children: [
//                               Container(
//                                 width: 12,
//                                 height: 12,
//                                 decoration: BoxDecoration(
//                                   color: priority.color,
//                                   shape: BoxShape.circle,
//                                 ),
//                               ),
//                               const SizedBox(width: 8),
//                               Text(priority.displayName),
//                             ],
//                           ),
//                         );
//                       }).toList(),
//                       onChanged: (value) {
//                         if (value != null) {
//                           setState(() {
//                             _selectedPriority = value;
//                           });
//                         }
//                       },
//                     ),
//                   ),
//                   const SizedBox(width: 16),
//                   Expanded(
//                     child: DropdownButtonFormField<TaskDifficulty>(
//                       value: _selectedDifficulty,
//                       decoration: const InputDecoration(
//                         labelText: 'Сложность',
//                         border: OutlineInputBorder(),
//                       ),
//                       items: allTaskDifficulties.map((difficulty) {
//                         return DropdownMenuItem(
//                           value: difficulty,
//                           child: Row(
//                             children: [
//                               Container(
//                                 width: 12,
//                                 height: 12,
//                                 decoration: BoxDecoration(
//                                   color: difficulty.color,
//                                   shape: BoxShape.circle,
//                                 ),
//                               ),
//                               const SizedBox(width: 8),
//                               Text(difficulty.displayName),
//                             ],
//                           ),
//                         );
//                       }).toList(),
//                       onChanged: (value) {
//                         if (value != null) {
//                           setState(() {
//                             _selectedDifficulty = value;
//                           });
//                         }
//                       },
//                     ),
//                   ),
//                 ],
//               ),
//               const SizedBox(height: 16),
              
//               // Статус
//               SwitchListTile(
//                 title: const Text('Выполнено'),
//                 value: _isDone,
//                 onChanged: (value) {
//                   setState(() {
//                     _isDone = value;
//                   });
//                 },
//                 activeColor: Colors.deepPurple,
//               ),
//               const SizedBox(height: 16),
              
//               // Теги
//               const Text(
//                 'Теги',
//                 style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
//               ),
//               const SizedBox(height: 8),
//               _buildTagsSelector(),
//               const SizedBox(height: 16),
              
//               // Награды
//               const Text(
//                 'Награды',
//                 style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
//               ),
//               const SizedBox(height: 8),
//               _buildRewardsSection(),
//               const SizedBox(height: 24),
              
//               // Кнопки
//               Row(
//                 children: [
//                   Expanded(
//                     child: ElevatedButton(
//                       onPressed: _saveTask,
//                       style: ElevatedButton.styleFrom(
//                         backgroundColor: Colors.deepPurple,
//                         foregroundColor: Colors.white,
//                         padding: const EdgeInsets.symmetric(vertical: 16),
//                       ),
//                       child: Text(widget.task == null ? 'Создать' : 'Сохранить'),
//                     ),
//                   ),
//                 ],
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
  
//   Widget _buildTagsSelector() {
//     return Consumer<TagProvider>(
//       builder: (context, tagProvider, child) {
//         final allTags = tagProvider.tags;
        
//         if (allTags.isEmpty) {
//           return const Text('Нет доступных тегов');
//         }
        
//         return Wrap(
//           spacing: 8,
//           children: allTags.map((tag) {
//             final isSelected = _selectedTags.any((t) => t.id == tag.id);
            
//             return FilterChip(
//               label: Text(tag.title),
//               selected: isSelected,
//               onSelected: (selected) {
//                 setState(() {
//                   if (selected) {
//                     _selectedTags.add(tag);
//                   } else {
//                     _selectedTags.removeWhere((t) => t.id == tag.id);
//                   }
//                 });
//               },
//               backgroundColor: Colors.grey[200],
//               selectedColor: tag.type.color.withOpacity(0.3),
//               labelStyle: TextStyle(
//                 color: isSelected ? tag.type.color : Colors.black87,
//                 fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
//               ),
//               shape: StadiumBorder(
//                 side: BorderSide(
//                   color: isSelected ? tag.type.color : Colors.transparent,
//                 ),
//               ),
//             );
//           }).toList(),
//         );
//       },
//     );
//   }
  
//   Widget _buildRewardsSection() {
//     return Column(
//       children: [
//         ..._rewards.map((reward) {
//           return ListTile(
//             title: Text('Награда ${_rewards.indexOf(reward) + 1}'),
//             subtitle: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text('Опыт: ${reward.experience}'),
//                 Text('Время: ${reward.time} минут'),
//               ],
//             ),
//             trailing: IconButton(
//               icon: const Icon(Icons.delete, color: Colors.red),
//               onPressed: () {
//                 setState(() {
//                   _rewards.remove(reward);
//                 });
//               },
//             ),
//           );
//         }).toList(),
//         if (_rewards.isNotEmpty) const Divider(),
//         ElevatedButton.icon(
//           onPressed: _addReward,
//           icon: const Icon(Icons.add),
//           label: const Text('Добавить награду'),
//           style: ElevatedButton.styleFrom(
//             backgroundColor: Colors.grey[200],
//             foregroundColor: Colors.black87,
//           ),
//         ),
//       ],
//     );
//   }
  
//   Future<void> _selectDate() async {
//     final picked = await showDatePicker(
//       context: context,
//       initialDate: _selectedDate ?? DateTime.now(),
//       firstDate: DateTime(2020),
//       lastDate: DateTime(2030),
//     );
//     if (picked != null) {
//       setState(() {
//         _selectedDate = picked;
//       });
//     }
//   }
  
//   Future<void> _selectTime() async {
//     final picked = await showTimePicker(
//       context: context,
//       initialTime: _selectedTime ?? TimeOfDay.now(),
//     );
//     if (picked != null) {
//       setState(() {
//         _selectedTime = picked;
//       });
//     }
//   }
  
//   void _addReward() {
//     // Показываем диалог для создания награды
//     showDialog(
//       context: context,
//       builder: (context) => AlertDialog(
//         title: const Text('Добавить награду'),
//         content: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             TextFormField(
//               decoration: const InputDecoration(labelText: 'Опыт'),
//               keyboardType: TextInputType.number,
//               onChanged: (value) {
//                 // Сохраняем в переменную
//               },
//             ),
//             TextFormField(
//               decoration: const InputDecoration(labelText: 'Время (минуты)'),
//               keyboardType: TextInputType.number,
//               onChanged: (value) {
//                 // Сохраняем в переменную
//               },
//             ),
//           ],
//         ),
//         actions: [
//           TextButton(
//             onPressed: () => Navigator.pop(context),
//             child: const Text('Отмена'),
//           ),
//           TextButton(
//             onPressed: () {
//               // Упрощённое создание награды
//               setState(() {
//                 _rewards.add(Reward(
//                   id: DateTime.now().millisecondsSinceEpoch.toString(),
//                   skillId: 'skill_1',
//                   taskId: widget.task?.id ?? '',
//                   experience: 10,
//                   time: 5,
//                 ));
//               });
//               Navigator.pop(context);
//             },
//             child: const Text('Добавить'),
//           ),
//         ],
//       ),
//     );
//   }
  
//   void _saveTask() {
//     if (!_formKey.currentState!.validate()) return;
    
//     DateTime? dateTime;
//     if (_selectedDate != null && _selectedTime != null) {
//       dateTime = DateTime(
//         _selectedDate!.year,
//         _selectedDate!.month,
//         _selectedDate!.day,
//         _selectedTime!.hour,
//         _selectedTime!.minute,
//       );
//     }
    
//     final task = widget.task?.copyWith(
//       title: _titleController.text,
//       description: _descriptionController.text,
//       datetime: dateTime,
//       done: _isDone,
//       priority: _selectedPriority,
//       difficulty: _selectedDifficulty,
//     ) ?? Task.create(
//       title: _titleController.text,
//       description: _descriptionController.text,
//       datetime: dateTime,
//       done: _isDone,
//       priority: _selectedPriority,
//       difficulty: _selectedDifficulty,
//     );
    
//     final taskProvider = Provider.of<TaskProvider>(context, listen: false);
    
//     if (widget.task == null) {
//       // Добавляем новую задачу
//       if (widget.parentId != null) {
//         taskProvider.addSubtask(widget.parentId!, task);
//       } else {
//         taskProvider.addTask(
//           task,
//           tagIds: _selectedTags.map((t) => t.id).toList(),
//           rewards: _rewards,
//         );
//       }
//     } else {
//       // Обновляем задачу
//       taskProvider.updateTask(
//         task,
//         tagIds: _selectedTags.map((t) => t.id).toList(),
//         rewards: _rewards,
//       );
//     }
    
//     Navigator.pop(context, true);
//   }

  
//   void _confirmDelete() {
//     showDialog(
//       context: context,
//       builder: (context) => AlertDialog(
//         title: const Text('Удалить задачу?'),
//         content: const Text('Это действие нельзя отменить.'),
//         actions: [
//           TextButton(
//             onPressed: () => Navigator.pop(context),
//             child: const Text('Отмена'),
//           ),
//           TextButton(
//             onPressed: () {
//               final taskProvider = Provider.of<TaskProvider>(context, listen: false);
//               taskProvider.deleteTask(widget.task!.id);
//               Navigator.pop(context);
//               Navigator.pop(context, true);
//             },
//             style: TextButton.styleFrom(foregroundColor: Colors.red),
//             child: const Text('Удалить'),
//           ),
//         ],
//       ),
//     );
//   }
// }