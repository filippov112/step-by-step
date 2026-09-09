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
  final bool noShadow;
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
    this.noShadow = false
  });

  @override
  Widget build(BuildContext context) {

    var txt = Text(
      text,
      textAlign: align,
      style: TextStyle(
              height: height,
              fontSize: size,
              color: color,
              fontWeight: weight,
              shadows: noShadow ? null : [ shadow ?? Shadow(color: Theme.of(context).colorScheme.onPrimary, blurRadius: 4)],
              decoration: decoration,
            ),
      maxLines: lines,
      overflow: overflow,
    );
    var pdng = padding == null ? txt : Padding(padding: padding!, child: txt);
    return expanded ? Expanded(flex: expandedFlex, child: pdng) : pdng;
  }
}
