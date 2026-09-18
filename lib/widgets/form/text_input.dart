import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CustomTextInput extends StatelessWidget {
  final TextEditingController? controller;
  final String? header;
  final IconData? icon;
  final String? requiredErrorText;
  final Function(String?) setText;
  final int? lines;
  final String? Function(String?)? customValidator;
  final String? initialValue;
  final TextInputType? type;
  final TextInputAction? action;
  final int? length;

  const CustomTextInput({
    super.key,
    required this.header,
    this.controller,
    required this.setText,
    this.icon,
    this.requiredErrorText,
    this.lines,
    this.customValidator,
    this.initialValue,
    this.type,
    this.action = TextInputAction.done,
    this.length
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      textInputAction: action,
      maxLength: length,
      onChanged: setText,
      keyboardType: type,
      inputFormatters: type == TextInputType.number ? [
        FilteringTextInputFormatter.digitsOnly, 
      ] : null,
      initialValue: initialValue,
      decoration: InputDecoration(
        labelText: header,
        border: const OutlineInputBorder(),
        prefixIcon: icon == null ? null : Icon(icon),
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
