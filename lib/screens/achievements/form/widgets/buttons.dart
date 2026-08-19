import 'package:flutter/material.dart';

Widget buildButtonsBlock(BuildContext context, {
  required VoidCallback saveCallback,
  required bool isEditing
}) {
  return Padding(
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
            onPressed: saveCallback,
            child: Text(isEditing ? 'Сохранить' : 'Создать'),
          ),
        ),
      ],
    ),
  );
}