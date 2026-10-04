import 'package:step_by_step/widgets/common/custom_text.dart';
import 'package:flutter/material.dart';

class CustomLoadingScreen extends StatelessWidget {
  const CustomLoadingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final focusColor = Theme.of(context).focusColor;

    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CircularProgressIndicator(color: focusColor),
          const SizedBox(height: 12),
          const CustomText('Выполнение операции...'),
        ],
      ),
    );
  }
  
}