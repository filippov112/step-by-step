import 'package:flutter/material.dart';

class CustomMultilineTextInput extends StatelessWidget {
  final TextEditingController controller;
  final String? header;
  final Function(String?) setText;

  const CustomMultilineTextInput({
    super.key,
    required this.header,
    required this.controller,
    required this.setText,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      onChanged: setText,
      decoration: InputDecoration(
        labelText: header,
        border: const OutlineInputBorder(),
        prefixIcon: const Icon(Icons.description),
      ),
      maxLines: null,
    );
  }
}
