import 'package:chaos_control/widgets/common/custom_text.dart';
import 'package:flutter/material.dart';

class BottomModalForm extends StatefulWidget {
  final Key? formKey;
  final String title;
  final Iterable<Widget> children;
  final VoidCallback confirmCallback;
  const BottomModalForm({
    super.key,
    this.formKey,
    required this.title,
    required this.children,
    required this.confirmCallback
  });

  @override
  State<StatefulWidget> createState() => BottomModalFormState();
}

class BottomModalFormState extends State<BottomModalForm> {
  void _close() {
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsetsGeometry.fromLTRB(12, 6, 12, 12),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CustomText(
                widget.title,
                size: 18,
                padding: const EdgeInsets.fromLTRB(8, 0, 12, 4),
              ),

              const Spacer(),

              Padding(
                padding: const EdgeInsets.only(bottom: 4, right: 12),
                child: IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: _close,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 4),
                child: ElevatedButton(
                  onPressed: widget.confirmCallback,
                  child: Icon(Icons.done),
                ),
              ),
              
            ],
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
