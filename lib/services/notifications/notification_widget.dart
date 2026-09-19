import 'dart:async';
import 'package:chaos_control/services/sound_service.dart';
import 'package:chaos_control/widgets/common/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class NotificationWidget extends StatefulWidget {
  final Widget item;
  final SoundType soundType;
  final VoidCallback onDismiss;
  final int duration;

  const NotificationWidget({
    super.key,
    required this.item,
    required this.duration,
    required this.onDismiss,
    required this.soundType,
  });

  @override
  State<NotificationWidget> createState() => _NotificationWidgetState();
}

class _NotificationWidgetState extends State<NotificationWidget>
    with TickerProviderStateMixin {
  late AnimationController _slideController, _fadeController;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _fadeAnimation;
  late SoundService _soundService;

  @override
  void initState() {
    super.initState();
    _soundService = context.read<SoundService>();
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
    _soundService.play(widget.soundType);
    _slideController.forward();
    await _fadeController.forward();
    Timer(Duration(milliseconds: (widget.duration * 0.5).toInt()), () async {
      await _fadeController.reverse();
      widget.onDismiss();
    });
  }

  @override
  Widget build(BuildContext context) {
    final onPrimaryColor = Theme.of(
      context,
    ).colorScheme.onPrimary.withAlpha(150);
    final focusColor = Theme.of(
      context,
    ).focusColor;

    final container = GestureDetector(
      onTap: () async {
        await _fadeController.reverse();
        widget.onDismiss();
      },
      child: Material(
        elevation: 6,
        shadowColor: focusColor,
        child: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            border: Border.all(width: 1, color: focusColor),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: EdgeInsetsGeometry.all(8),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Иконка
                    Container(
                      height: 30,
                      decoration: BoxDecoration(
                        border: Border.all(width: 1, color: onPrimaryColor),
                      ),
                      padding: const EdgeInsets.all(2),
                      child: Center(
                        child: Icon(
                          Icons.error_outline,
                          color: onPrimaryColor.withAlpha(255),
                          shadows: [
                            Shadow(
                              color: onPrimaryColor.withAlpha(255),
                              blurRadius: 14,
                            ),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(width: 8),

                    // Надпись
                    Container(
                      height: 30,
                      decoration: BoxDecoration(
                        border: Border.all(width: 1, color: onPrimaryColor),
                      ),
                      padding: const EdgeInsets.symmetric(
                        vertical: 1,
                        horizontal: 12,
                      ),
                      child: Center(
                        child: CustomText(
                          'NOTIFICATION',
                          weight: const FontWeight(500),
                          size: 18,
                          shadow: Shadow(
                            color: onPrimaryColor.withAlpha(255),
                            blurRadius: 16,
                          ),
                          color: onPrimaryColor.withAlpha(255),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              widget.item,
            ],
          ),
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
