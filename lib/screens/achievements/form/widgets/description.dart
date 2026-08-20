import 'package:flutter/material.dart';

Widget buildDescriptionInput({
  required TextEditingController? controller
}) {

  return TextFormField(
    controller: controller,
    decoration: const InputDecoration(
      labelText: 'Описание',
      border: OutlineInputBorder(),
      prefixIcon: Icon(Icons.description),
    ),
    maxLines: 3,
  );
}