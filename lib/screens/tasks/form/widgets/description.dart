import 'package:flutter/material.dart';

Widget buildDescriptionInput({
  required String selectedDescription,
  required Function(String) setDescription
}) {
  return TextFormField(
    initialValue: selectedDescription,
    onSaved: (val) => setDescription(val ?? ''),
    decoration: const InputDecoration(
      labelText: 'Описание',
      border: OutlineInputBorder(),
      prefixIcon: Icon(Icons.description),
    ),
    maxLines: 3,
  );
}