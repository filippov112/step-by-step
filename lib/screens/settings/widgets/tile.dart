import 'package:chaos_control/widgets/common/custom_text.dart';
import 'package:chaos_control/widgets/common/custom_tile.dart';
import 'package:flutter/material.dart';

class SettingsTile extends StatelessWidget {
  final String title;
  final Widget Function() widgetCallback;
  const SettingsTile({
    super.key,
    required this.title,
    required this.widgetCallback,
  });

  @override
  Widget build(BuildContext context) {
    final focusColor = Theme.of(context).focusColor;
    final cardColor = Theme.of(context).cardColor;
    final primaryColor = Theme.of(context).primaryColor;

    return Padding(
      padding: const EdgeInsetsGeometry.only(bottom: 6),
      child: CustomTile(
        padding: 12,
        borderWidth: 0,
        borderColor: Colors.transparent,
        background: cardColor,
        borderRadius: 8,
        callback: () => _open(context),
        child: Row(
          children: [
            Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: focusColor,
                boxShadow: [BoxShadow(color: focusColor, blurRadius: 5)]
              ),
              padding: const EdgeInsets.all(6),
              child: Icon(Icons.scale, size: 18, color: primaryColor),
            ),
            const SizedBox(width: 16),
            CustomText(title, size: 16, expanded: true),
          ],
        ),
      ),
    );
  }

  void _open(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => widgetCallback()),
    );
  }
}
