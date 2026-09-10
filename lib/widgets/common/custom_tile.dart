import 'package:flutter/material.dart';

class CustomTile extends StatelessWidget {
  final double? borderRadius;
  final double? borderWidth;
  final Color? borderColor;
  final double? padding;
  final Widget child;
  final Color? background;
  final VoidCallback? callback, longPressCallback;

  const CustomTile({super.key, 
    required this.child,
    this.borderRadius, 
    this.padding,
    this.background,
    this.callback,
    this.borderColor,
    this.borderWidth,
    this.longPressCallback
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onLongPress: longPressCallback,
      onTap: callback,
      borderRadius: borderRadius != null ? BorderRadius.all(Radius.circular(borderRadius!)) : null,
      child: Container(
        padding: padding != null ? EdgeInsets.all(padding!) : null,
        decoration: BoxDecoration(
          color: background ?? Theme.of(context).cardColor.withAlpha(200),
          borderRadius: borderRadius != null ? BorderRadius.all(Radius.circular(borderRadius!)) : null,
          border: Border.all(
            color: borderColor ?? Theme.of(context).dividerColor, 
            width: borderWidth ?? 1)
        ),
        child: child
        ),
    );
  }
}