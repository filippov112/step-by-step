import 'package:flutter/material.dart';
import 'package:life_game/widgets/common/custom_text.dart';

Widget buildHeader({
  required String title,
}) {
  // Заголовок и статус
  return CustomText(
    title, 
    size: 20, 
    weight: const FontWeight(500), 
    lines: 3,
    padding: EdgeInsets.all(8)
  );
}
