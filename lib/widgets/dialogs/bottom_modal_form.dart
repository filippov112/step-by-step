import 'package:chaos_control/widgets/common/custom_text.dart';
import 'package:flutter/material.dart';

class BottomModalForm extends StatefulWidget {
  final Key? formKey;
  final String title;
  final Iterable<Widget> children;
  final VoidCallback confirmCallback;
  final VoidCallback? closeCallback;
  final IconData? confirmIcon;

  const BottomModalForm({
    super.key,
    this.formKey,
    required this.title,
    required this.children,
    required this.confirmCallback,
    this.closeCallback,
    this.confirmIcon,
  });

  @override
  State<StatefulWidget> createState() => BottomModalFormState();
}

class BottomModalFormState extends State<BottomModalForm> {
  void _close() {
    if (widget.closeCallback != null) {
      widget.closeCallback?.call();
      return;
    }
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsetsGeometry.fromLTRB(8, 6, 8, 6),
      child: Column(
        children: [
          Container(
            height: 46,
            padding: const EdgeInsets.fromLTRB(8, 4, 8, 4),
            child: Column(
              children: [
                Expanded(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Заголовок
                      CustomText(widget.title, size: 18, expanded: true),
                      const SizedBox(width: 12),

                      // Закрыть
                      IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: _close,
                      ),
                      const SizedBox(width: 12),

                      // Сохранить
                      IconButton(
                        onPressed: widget.confirmCallback,
                        icon: Icon(widget.confirmIcon ?? Icons.done),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          Expanded(
            child: SingleChildScrollView(
              child: Form(
                key: widget.formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [...widget.children],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
