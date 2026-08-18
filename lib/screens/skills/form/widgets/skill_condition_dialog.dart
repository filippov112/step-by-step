import 'package:flutter/material.dart';
import 'package:life_game/models/skill_condition.dart';
import 'package:life_game/models/enums/skill_rang.dart';

class ConditionDialog extends StatefulWidget {
  final SkillCondition? existingCondition;
  final int? editIndex;
  
  const ConditionDialog({
    super.key,
    this.existingCondition,
    this.editIndex,
  });

  @override
  State<ConditionDialog> createState() => _ConditionDialogState();
}

class _ConditionDialogState extends State<ConditionDialog> {
  late SkillRang _selectedRang;
  late TextEditingController _descriptionController;
  late DateTime? _selectedDate;
  
  @override
  void initState() {
    super.initState();
    if (widget.existingCondition != null) {
      _selectedRang = widget.existingCondition!.rang;
      _descriptionController = TextEditingController(text: widget.existingCondition!.description);
      _selectedDate = widget.existingCondition!.date;
    } else {
      _selectedRang = SkillRang.F;
      _descriptionController = TextEditingController();
      _selectedDate = DateTime.now();
    }
  }

  @override
  void dispose() {
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      insetPadding: EdgeInsets.all(8),
      title: Text(widget.existingCondition != null ? 'Редактирование условия' : 'Добавление условия'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Выбор ранга
            DropdownButtonFormField<SkillRang>(
              decoration: const InputDecoration(
                labelText: 'Ранг',
                border: OutlineInputBorder(),
              ),
              initialValue: _selectedRang,
              items: SkillRang.values.map((rang) {
                return DropdownMenuItem(
                  value: rang,
                  child: Text(rang.name),
                );
              }).toList(),
              onChanged: (value) {
                if (value != null) {
                  setState(() {
                    _selectedRang = value;
                  });
                }
              },
            ),
            const SizedBox(height: 16),
            
            // Описание
            TextField(
              controller: _descriptionController,
              decoration: const InputDecoration(
                labelText: 'Описание условия',
                border: OutlineInputBorder(),
                hintText: 'Например: Выполнить 10 заданий',
              ),
              maxLines: 3,
            ),
 
            // Дата
            Padding(
              padding: EdgeInsetsGeometry.all(8),
              child:Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    _selectedDate != null
                      ? 'Дата: ${_selectedDate!.day}.${_selectedDate!.month}.${_selectedDate!.year}'
                      : 'Дата не выбрана',
                  ),
                  IconButton(
                    icon: const Icon(Icons.calendar_today),
                    onPressed: () async {
                      final date = await showDatePicker(
                        context: context,
                        initialDate: _selectedDate ?? DateTime.now(),
                        firstDate: DateTime(2000),
                        lastDate: DateTime(2100),
                      );
                      if (date != null) {
                        setState(() {
                          _selectedDate = date;
                        });
                      }
                    },
                  ),
                ],
              ),
            ),
            
            // Кнопка очистки даты
            if (_selectedDate != null) SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                onPressed: () {
                  setState(() {
                    _selectedDate = null;
                  });
                },
                child: const Text('Очистить дату'),
              ),
            ),
          ],
        ),
      ),
      actions: [
        SizedBox(
          width: double.infinity,
          child: Row(
            mainAxisSize: MainAxisSize.max,
            children: [
              Expanded(
                flex: 1,
                child: IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.close),
                ),
              ),
              SizedBox(width: 8,),
              Expanded(
                flex: 1, 
                child: IconButton(
                  onPressed: () {
                    final condition = SkillCondition(
                      id: widget.existingCondition?.id ?? '',
                      rang: _selectedRang,
                      skillId: widget.existingCondition?.skillId ?? '',
                      description: _descriptionController.text.trim(),
                      date: _selectedDate,
                    );
                    Navigator.pop(context, {
                      'condition': condition,
                      'editIndex': widget.editIndex,
                    });
                  },
                  icon: const Icon(Icons.save),
                ),
              ),
            ],
          ),
        )
        
      ],
    );
  }
}