import 'package:flutter/material.dart';

class CustomText extends StatelessWidget {
  final String text;
  final double? size;
  final Color? color;
  final TextOverflow? overflow;
  final FontWeight? weight;
  final int? lines;
  final EdgeInsetsGeometry? padding;
  final Shadow? shadow;
  final bool expanded;
  final int expandedFlex;
  final TextAlign align;
  final double? height;
  final TextDecoration? decoration;

  const CustomText(
    this.text, {
    super.key,
    this.size,
    this.color,
    this.overflow = TextOverflow.ellipsis,
    this.weight,
    this.lines = 1,
    this.padding,
    this.shadow,
    this.expanded = false,
    this.expandedFlex = 1,
    this.align = TextAlign.start,
    this.height,
    this.decoration,
  });

  @override
  Widget build(BuildContext context) {
    final isCustomStyle =
        height != null ||
        size != null ||
        color != null ||
        weight != null ||
        shadow != null ||
        decoration != null;

    var txt = Text(
      text,
      textAlign: align,
      style: isCustomStyle
          ? TextStyle(
              height: height,
              fontSize: size,
              color: color,
              fontWeight: weight,
              shadows: shadow == null ? null : [shadow!],
              decoration: decoration,
            )
          : null,
      maxLines: lines,
      overflow: overflow,
    );
    var pdng = padding == null ? txt : Padding(padding: padding!, child: txt);
    return expanded ? Expanded(flex: expandedFlex, child: pdng) : pdng;
  }
}
