
import 'package:flutter/material.dart';

class ListCheckbox extends StatelessWidget {
  const ListCheckbox({
    super.key, 
    required this.displayNames, 
    required this.values, 
    required this.callback, 
    required this.ids
  });
  final List<String> displayNames;
  final List<bool> values;
  final List<String> ids;
  final Function(String, bool?) callback;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(8),
      itemCount: ids.length,
      itemBuilder: (context, index) {
        return ListTile(
          leading: Checkbox(value: values[index], onChanged:  (val) => callback.call(ids[index], val)),
          title: Text(displayNames[index]),
        );
      }
    );
  }
  
}