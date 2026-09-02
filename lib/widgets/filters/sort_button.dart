import 'package:flutter/material.dart';

class SortButton<T> extends StatelessWidget {

  final T sortField;
  final Function(T) setSortField;
  final bool sortAscending;
  final T field;
  final String label;

  const SortButton({
    super.key,
    required this.sortAscending,
    required this.sortField,
    required this.setSortField,
    required this.field,
    required this.label
  });

  @override
  Widget build(BuildContext context) {
    final isActive = sortField == field;
    return OutlinedButton(
      onPressed: () => setSortField(field),
      style: OutlinedButton.styleFrom(
        backgroundColor: isActive
            ? Theme.of(context).colorScheme.primaryContainer
            : null,
        side: isActive
            ? BorderSide(color: Theme.of(context).colorScheme.primary)
            : null,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label),
          if (isActive)
            Icon(
              sortAscending ? Icons.arrow_upward : Icons.arrow_downward,
              size: 16,
            ),
        ],
      ),
    );
  }
  
}