import 'package:flutter/material.dart';

// Поисковая строка для AppBar.bottom в экранах-списках
class SearchString extends StatelessWidget {
  final String placeholder;
  final TextEditingController controller;
  final String value;
  final VoidCallback clearCallback;
  final Function(String) changeCallback;

  const SearchString({super.key, 
    required this.placeholder,
    required this.controller,
    required this.value,
    required this.clearCallback,
    required this.changeCallback
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          hintText: placeholder,
          prefixIcon: const Icon(Icons.search),
          suffixIcon: value.isNotEmpty ? IconButton(
            icon: const Icon(Icons.clear), 
            onPressed: () {
              clearCallback.call();
              controller.clear();
            } 
          ) : null,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide.none,
          ),
          filled: true,
          contentPadding: const EdgeInsets.symmetric(horizontal: 16),
        ),
        onChanged: changeCallback,
      ),
    );
  }  
}
