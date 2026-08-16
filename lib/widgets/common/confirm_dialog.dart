import 'package:flutter/material.dart';
import 'package:life_game/widgets/common/custom_text.dart';


// Диалог подтверждения действий
Future<bool?> showConfirmDialog(
  BuildContext context, {
  final Widget? title, 
  final Widget? text,
  final Widget? back,
  final Widget? confirm
}) async {

  return await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        insetPadding: EdgeInsets.all(8),
        title: title ?? const CustomText('Подтверждение', size: 16, weight: FontWeight.bold),
        content: text ?? const CustomText('Вы уверены?'),
        actions: [
          Row(children: [
            Expanded(
              child: OutlinedButton(
                onPressed: () => Navigator.pop(context, false),
                child: back ?? const CustomText('Нет'),
              ),
            ),
            const SizedBox(width: 8,),
            Expanded(
              child: ElevatedButton(
                onPressed: () => Navigator.pop(context, true),
                child: confirm ?? const CustomText('Да'),
              ),
            )
          ],
        )
          
          
        ],
      ),
    );
}