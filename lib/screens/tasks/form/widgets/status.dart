import 'package:flutter/material.dart';

Widget buildStatusSection({ 
  required bool selectedDone, 
  required Function(bool) setDone 
}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          
          Checkbox(value: selectedDone, onChanged: (val) => setDone(val ?? false)),
            
          Text('Выполнена')
        ],
      ),
    ],
  );
}