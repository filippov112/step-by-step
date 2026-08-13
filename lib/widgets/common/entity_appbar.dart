import 'package:flutter/material.dart';

PreferredSizeWidget buildAppBar(
  String title, 
  {
    VoidCallback? editCallback, 
    VoidCallback? deleteCallback
  }
) {
  return AppBar(
    title: Text(title),
    actions: [
      if (editCallback != null)
        IconButton(
          icon: const Icon(Icons.edit),
          onPressed: () => editCallback(),
          tooltip: 'Редактировать',
        ),
      if (deleteCallback != null)
        IconButton(
          icon: const Icon(Icons.delete),
          onPressed: () => deleteCallback(),
          tooltip: 'Удалить',
        ),
    ],
  );
}