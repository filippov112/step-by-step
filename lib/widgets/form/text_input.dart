import 'package:flutter/material.dart';

class CustomTextInput extends StatelessWidget {
  final TextEditingController? controller;
  final String? header;
  final IconData icon;
  final String? requiredErrorText;
  final Function(String?) setText;
  final int? lines;
  final String? Function(String?)? customValidator;
  final String? initialValue;

  const CustomTextInput({
    super.key,
    required this.header,
    this.controller,
    required this.setText,
    required this.icon,
    this.requiredErrorText,
    this.lines,
    this.customValidator,
    this.initialValue
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      textInputAction: TextInputAction.done,
      onChanged: setText,
      initialValue: initialValue,
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
