import 'dart:io';

import 'package:flutter/material.dart';
import 'package:life_game/models/other/image.dart';
import 'package:life_game/services/file_storage_service.dart';
import 'package:life_game/widgets/dialogs/icons/icons_finder_dialog.dart';

class CustomIconPicker extends StatelessWidget {
  final iconService = IconsFinderService();

  CustomIconPicker({
    super.key,
    required this.selectedIcon,
    required this.setIcon,
    this.size = 80,
    this.borderWidth,
    this.radius,
    this.color,
  });

  final CustomImageData? selectedIcon;
  final Function(CustomImageData?) setIcon;
  final double size;
  final BorderRadiusGeometry? radius;
  final double? borderWidth;
  final Color? color;

  // Выбор изображения
  Future<bool> pickImage(BuildContext context) async {
    try {
      final file = await FileService.pickImageFromGallery();
      if (file == null) return false;

      final savedPath = await FileService.saveIcon(file);
      if (savedPath != null) {
        setIcon(CustomImageData.fromImage(savedPath));
      }
      return false;
    } catch (e) {
      return false;
    }
  }

  // Выбор иконки
  Future<bool> pickIcon(BuildContext context) async {
    try {
      final icon = await iconService.select(context);
      if (icon == null) return false;
      setIcon(CustomImageData.fromIcon(icon));
      return true;
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

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            borderRadius: borderRadius,
            color: backColor,
            border: border,
          ),
          child:
              selectedIcon == null ||
                  (!selectedIcon!.isIcon && !selectedIcon!.isImage) ||
                  selectedIcon!.isIcon
              ? Center(
                  child: Icon(
                    selectedIcon?.icon() ?? Icons.image,
                    size: size * 0.6,
                    color: foreColor,
                  ),
                )
              : ClipRRect(
                  borderRadius: borderRadius,
                  child: Image.file(
                    File(selectedIcon!.imagePath!),
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

        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              onPressed: () => pickImage(context),
              icon: Icon(Icons.image),
            ),
            IconButton(
              onPressed: () => pickIcon(context),
              icon: Icon(Icons.abc),
            ),
            IconButton(onPressed: deleteIcon, icon: Icon(Icons.clear)),
          ],
        ),
      ],
    );
  }
}
