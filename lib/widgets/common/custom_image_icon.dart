import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';

class CustomImageIcon extends StatelessWidget {
  final String? path;
  final BorderRadius radius;
  final double width;
  final double height;
  final Color? color;
  final IconData icon;
  final Color? borderColor;
  final double? borderWidth;

  const CustomImageIcon(this.path, {super.key, 
    required this.icon,
    this.radius = const BorderRadius.all(Radius.circular(8)),
    this.width = 48,
    this.height = 48,
    this.color,
    this.borderColor,
    this.borderWidth
  });

  File? getFile() {
    if (path == null || path!.isEmpty) return null;
    try {
      return File(path!);
    } catch (e) {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    
    final file = getFile();
    final backColor = (color ?? Theme.of(context).dividerColor).withValues(alpha:0.15);
    final iconSize = min(width, height) * 0.6;
    final border = Border.all(
      color: borderColor ?? Theme.of(context).dividerColor, 
      width: borderWidth ?? 0
    );

    return path == null || path!.isEmpty ?
      Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          borderRadius: radius,
          color: backColor,
          border: border
        ),
        child: Icon(icon, color: color, size: iconSize),
      ) :

      (file == null ?

      Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: backColor,
          borderRadius: radius,
          border: border
        ),
        child:  Icon(Icons.image_not_supported, color: color, size: iconSize),
      ) :

      Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: backColor,
          borderRadius: radius,
          border: border
        ),
        child: ClipRRect(
          borderRadius: radius,
          clipBehavior: Clip.hardEdge,
          child: Image.file(
            file,
            width: width,
            height: height,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) {
              return Container(
                width: width,
                height: height,
                decoration: BoxDecoration(
                  color: backColor,
                  borderRadius: radius,
                  border: border
                ),
                child: Icon(Icons.broken_image, color: color, size: iconSize),
              );
            },
          ),
        ),
      )
    );
  }
} 