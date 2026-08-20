import 'package:flutter/material.dart';

Widget buildTitleInput({
  required String selectedTitle,
  required Function(String) setTitle
}) {
  return TextFormField(
    initialValue: selectedTitle,
    onSaved: (val) => setTitle.call(val ?? ''),
    decoration: const InputDecoration(
      labelText: 'Название',
      border: OutlineInputBorder(),
      prefixIcon: Icon(Icons.title),
    ),
    validator: (value) {
      if (value == null || value.isEmpty) {
        return 'Введите название';
      }
      return null;
    },
  );
}