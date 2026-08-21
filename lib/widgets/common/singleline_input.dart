import 'package:flutter/material.dart';

class SinglelineInput extends StatelessWidget {
  final String title;
  final bool isRequired;
  final String requiredErrorText;
  final TextEditingController controller;
  const SinglelineInput({super.key, required this.title, required this.controller, this.isRequired = false,
  required this.requiredErrorText});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: title,
        border: const OutlineInputBorder(),
        prefixIcon: const Icon(Icons.title),
      ),
      validator: (value) {
        if (!isRequired) return null;

        if ( value == null || value.isEmpty) {
          return requiredErrorText;
        }
        return null;
      },
    );
  }
}
