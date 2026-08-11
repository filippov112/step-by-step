import 'package:flutter/material.dart';

// Поисковая строка для AppBar.bottom в экранах-списках
PreferredSize buildSearchString({
  required String placeholder,
  required TextEditingController controller,
  required String value,
  required VoidCallback clearCallback,
  required Function(String) changeCallback
}) {

  return PreferredSize(
    preferredSize: const Size.fromHeight(60),
    child: Padding(
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
    ),
  );
}