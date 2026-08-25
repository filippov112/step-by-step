import 'package:flutter/material.dart';
import 'package:chaos_control/models/tag.dart';
import 'package:chaos_control/models/enums/tag_type.dart';

class TagEditDialog extends StatefulWidget {
  final Tag? tag;
  
  const TagEditDialog({super.key, this.tag});

  @override
  State<TagEditDialog> createState() => _TagEditDialogState();
}

class _TagEditDialogState extends State<TagEditDialog> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _titleController;
  late TagType _selectedType;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.tag?.title ?? '');
    _selectedType = widget.tag?.type ?? TagType.common;
  }

  @override
  void dispose() {
    _titleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    Widget tagTitle = TextFormField(
      controller: _titleController,
      decoration: const InputDecoration(
        labelText: 'Название тега',
        border: OutlineInputBorder(),
        hintText: 'Введите название',
      ),
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return 'Введите название тега';
        }
        return null;
      },
      autofocus: true,
    );

    Widget tagType = DropdownButtonFormField<TagType>(
      initialValue: _selectedType,
      decoration: const InputDecoration(
        labelText: 'Тип тега',
        border: OutlineInputBorder(),
      ),
      items: TagType.values.map((type) {
        return DropdownMenuItem(
          value: type,
          child: Text(type.displayName),
        );
      }).toList(),
      onChanged: (value) {
        if (value != null) {
          setState(() {
            _selectedType = value;
          });
        }
      },
    );

    return AlertDialog(
      insetPadding: const EdgeInsets.all(12),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            tagTitle,
            const SizedBox(height: 16),
            tagType,
          ],
        ),
      ),
      actions: [
        Row(
          children: [
            Expanded(
              child: IconButton(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(Icons.close),
              ),
            ),
            const SizedBox(width: 8,),
            Expanded(
              child: IconButton(
                onPressed: _saveTag,
                icon: const Icon(Icons.save),
              ),
            ),
        ],)
      ],
    );
  }

  void _saveTag() {
    if (_formKey.currentState!.validate()) {
      final tag = widget.tag?.copyWith(
        title: _titleController.text.trim(),
        type: _selectedType,
      ) ?? Tag.create(
        title: _titleController.text.trim(),
        type: _selectedType,
      );
      Navigator.pop(context, tag);
    }
  }

}
