import 'package:flutter/material.dart';

// Поисковая строка для AppBar.bottom в экранах-списках
class SearchString extends StatelessWidget {
  final String? placeholder;
  final TextEditingController controller;
  final String value;
  final Function(String) changeCallback;

  const SearchString({
    super.key,
    this.placeholder,
    required this.controller,
    this.value = '',
    required this.changeCallback,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        hintText: placeholder,
        prefixIcon: const Icon(Icons.search),
        suffixIcon: value.isNotEmpty
            ? IconButton(
                icon: const Icon(Icons.clear),
                onPressed: () {
                  controller.clear();
                  changeCallback.call('');
                },
              )
            : null,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide.none,
        ),
        filled: true,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16),
      ),
      onChanged: changeCallback,
    );
  }
}
