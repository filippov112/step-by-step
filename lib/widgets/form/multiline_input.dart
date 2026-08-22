import 'package:flutter/material.dart';

class CustomMultilineTextInput extends StatelessWidget {
  final TextEditingController controller;
  final String title;
  const CustomMultilineTextInput({super.key, required this.title, required this.controller});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: title,
        border: const OutlineInputBorder(),
        prefixIcon: const Icon(Icons.description),
      ),
      maxLines: null,
    );
  }
}
