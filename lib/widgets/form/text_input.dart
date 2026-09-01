import 'package:flutter/material.dart';

class CustomTextInput extends StatelessWidget {
  final TextEditingController controller;
  final String? header;
  final IconData icon;
  final String? requiredErrorText;
  final Function(String?) setText;
  final int? lines;
  final String? Function(String?)? customValidator;

  const CustomTextInput({
    super.key,
    required this.header,
    required this.controller,
    required this.setText,
    required this.icon,
    this.requiredErrorText,
    this.lines,
    this.customValidator
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      onChanged: setText,
      decoration: InputDecoration(
        labelText: header,
        border: const OutlineInputBorder(),
        prefixIcon: Icon(icon),
      ),
      maxLines: lines,
      validator: customValidator ?? (value) {
        if (requiredErrorText == null) return null;
        if (value == null || value.isEmpty) {
          return requiredErrorText;
        }
        return null;
      },
    );
  }
}
