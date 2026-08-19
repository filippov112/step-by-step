import 'dart:io';

import 'package:flutter/material.dart';
import 'package:life_game/services/file_storage_service.dart';
import 'package:life_game/widgets/common/custom_text.dart';


class CustomIconPicker extends StatelessWidget {
  CustomIconPicker({super.key, required this.currentIcon, required this.setIcon});

  final String? currentIcon;
  final Function(String?) setIcon;

  final FileStorageService fileStorage = FileStorageService();
  // Выбор иконки
  Future<bool> pickIcon() async {
    try {
      final file = await fileStorage.pickImageFromGallery();
      if (file == null) return false;
      
      final savedPath = await fileStorage.saveSkillIcon(file);
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
    return GestureDetector(
      onTap: () => pickIcon(),
      child: Container(
        width: double.infinity,
        height: 120,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: Theme.of(context).dividerColor.withAlpha(80),
        ),
        child: currentIcon == null
            ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.add_a_photo, size: 48),
                  const SizedBox(height: 8),
                  const CustomText(
                    'Нажмите для выбора иконки',
                    padding: EdgeInsets.all(12)
                  ),
                ],
              )
            : ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    Image.file(
                      File(currentIcon!),
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.broken_image, size: 48),
                            const SizedBox(height: 8),
                            const CustomText('Ошибка загрузки'),
                          ],
                        );
                      },
                    ),

                    Positioned(
                      top: 8,
                      right: 8,
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: Theme.of(context).primaryColor.withValues(alpha: 0.6),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: const Icon(
                          Icons.edit,
                          size: 20,
                        ),
                      ),
                    ),

                  ],
                ),
              ),
      ),
    );
  }
  
}
