import 'dart:async';
import 'package:flutter/material.dart';

class NotificationWidget extends StatefulWidget {
  final Widget item;
  final VoidCallback onDismiss;
  final int duration;

  const NotificationWidget({
    super.key,
    required this.item,
    required this.duration,
    required this.onDismiss,
  });

  @override
  State<NotificationWidget> createState() => _NotificationWidgetState();
}

class _NotificationWidgetState extends State<NotificationWidget>
    with TickerProviderStateMixin {
  late AnimationController _slideController, _fadeController;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _slideController = AnimationController(
      duration: Duration(milliseconds: (widget.duration * 0.25).toInt()),
      vsync: this,
    );
    _fadeController = AnimationController(
      duration: Duration(milliseconds: (widget.duration * 0.25).toInt()),
      vsync: this,
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, -1),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _slideController, curve: Curves.easeOut));

    _fadeAnimation = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(CurvedAnimation(parent: _fadeController, curve: Curves.easeOut));

    _startAnimation();
  }

  @override
  void dispose() {
    _slideController.dispose();
    super.dispose();
  }

  Future _startAnimation() async {
    _slideController.forward();
    await _fadeController.forward();
    Timer(Duration(milliseconds: (widget.duration * 0.5).toInt()), () async {
      await _fadeController.reverse();
      widget.onDismiss();
    });
  }

  @override
  Widget build(BuildContext context) {
    final container = GestureDetector(
      onTap: () async {
        await _fadeController.reverse();
        widget.onDismiss();
      },
      child: Material(
        elevation: 6,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(width: 3),
          ),
          child: widget.item,
        ),
      ),
    );

    return Positioned(
      top: MediaQuery.of(context).padding.top + 10,
      left: 16,
      right: 16,
      child: SlideTransition(
        position: _slideAnimation,
        child: FadeTransition(opacity: _fadeAnimation, child: container),
      ),
    );
  }
}
