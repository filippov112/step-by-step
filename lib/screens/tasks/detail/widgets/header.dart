import 'package:flutter/material.dart';

Widget buildHeader({
  required String title,
  required bool done,
  required Function() setDone,
}) {
  // Заголовок и статус
  return Row(
    crossAxisAlignment: CrossAxisAlignment.center,
    children: [
      Expanded(
        child: Padding(
          padding: EdgeInsetsGeometry.only(right:8), 
          child: Text(
            title, 
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ),
      ),
      Padding(
        padding: EdgeInsetsGeometry.only(left: 8), 
        child: Checkbox(
          value: done, 
          onChanged: (val) => setDone()
        )
      )
    ],
  );
}
