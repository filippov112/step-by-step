import 'package:flutter/material.dart';

class SinglelineInput extends StatelessWidget {
  final String header;
  final String? requiredErrorText;
  final TextEditingController controller;
  final Function(String?) setText;

  const SinglelineInput({
    super.key,
    required this.header,
    required this.controller,
    this.requiredErrorText,
    required this.setText
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: header,
        border: const OutlineInputBorder(),
        prefixIcon: const Icon(Icons.title),
      ),
      onChanged: setText,
      validator: (value) {
        if (requiredErrorText == null) return null;

        if (value == null || value.isEmpty) {
          return requiredErrorText;
        }
        return null;
      },
    );
  }
}
