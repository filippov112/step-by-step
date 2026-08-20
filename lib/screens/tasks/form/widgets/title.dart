import 'package:flutter/material.dart';

Widget buildTitleInput({
  required TextEditingController? controller,
}) {
  return TextFormField(
    controller: controller,
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
  );
}