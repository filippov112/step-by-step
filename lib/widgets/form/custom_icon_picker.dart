import 'dart:io';

import 'package:flutter/material.dart';
import 'package:life_game/services/file_storage_service.dart';

class CustomIconPicker extends StatelessWidget {
  const CustomIconPicker({
    super.key,
    required this.iconPath,
    required this.setIcon,
    this.size = 80,
    this.borderWidth,
    this.radius,
    this.color,
  });

  final String? iconPath;
  final Function(String?) setIcon;
  final double size;
  final BorderRadiusGeometry? radius;
  final double? borderWidth;
  final Color? color;

  // Выбор иконки
  Future<bool> pickIcon() async {
    try {
      final file = await FileService.pickImageFromGallery();
      if (file == null) return false;

      final savedPath = await FileService.saveIcon(file);
      if (savedPath != null) {
        setIcon(savedPath);
      }
      return false;
    } catch (e) {
      return false;
    }
  }

  // Удаление иконки
  Future<bool> deleteIcon() async {
    try {
      setIcon(null);
      return true;
    } catch (e) {
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    final backColor =
        color?.withAlpha(80) ?? Theme.of(context).dividerColor.withAlpha(80);
    final foreColor = color ?? Theme.of(context).focusColor;
    final borderRadius = radius ?? BorderRadius.circular(12);
    final border = borderWidth != null
        ? Border.all(color: foreColor, width: borderWidth!)
        : null;

    return GestureDetector(
      onTap: () => iconPath == null ? pickIcon() : deleteIcon(),
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          borderRadius: borderRadius,
          color: backColor,
          border: border,
        ),
        child: iconPath == null
            ? Center(
                child: Icon(
                  Icons.add_a_photo,
                  size: size * 0.6,
                  color: foreColor,
                ),
              )
            : ClipRRect(
                borderRadius: borderRadius,
                child: Image.file(
                  File(iconPath!),
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Center(
                      child: Icon(
                        Icons.broken_image,
                        size: size * 0.6,
                        color: foreColor,
                      ),
                    );
                  },
                ),
              ),
      ),
    );
  }
}
