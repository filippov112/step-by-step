import 'package:flutter/material.dart';

class CustomTile extends StatelessWidget {
  final double? borderRadius;
  final double? borderWidth;
  final Color? borderColor;
  final double? padding;
  final List<Widget> children;
  final Color? background;
  final VoidCallback? callback;

  const CustomTile({super.key, 
    required this.children,
    this.borderRadius, 
    this.padding,
    this.background,
    this.callback,
    this.borderColor,
    this.borderWidth
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: callback,
      borderRadius: borderRadius != null ? BorderRadius.all(Radius.circular(borderRadius!)) : null,
      child: Container(
        padding: padding != null ? EdgeInsets.all(padding!) : null,
        decoration: BoxDecoration(
          color: (background ?? Theme.of(context).cardColor).withValues(alpha:0.8),
          borderRadius: borderRadius != null ? BorderRadius.all(Radius.circular(borderRadius!)) : null,
          border: Border.all(
            color: borderColor ?? Theme.of(context).dividerColor, 
            width: borderWidth ?? 1)
        ),
        child: Row(
            children: [
              ...children,
            ],
          ),
        ),
    );
  }
}