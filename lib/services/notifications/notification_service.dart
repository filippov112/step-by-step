import 'dart:async';
import 'dart:collection';
import 'package:chaos_control/services/notifications/notification_item.dart';
import 'package:chaos_control/services/notifications/notification_widget.dart';
import 'package:flutter/material.dart';

class NotificationService {
  static const _duration = 2000;

  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  final Queue<NotificationItem> queue = Queue<NotificationItem>();
  bool _isShowing = false;
  
  // Для доступа к контексту (можно передавать через GlobalKey)
  OverlayEntry? _currentOverlay;
  Timer? _autoHideTimer;

  void showNotification(BuildContext context, NotificationItem item) {
    queue.add(item);
    _processQueue(context);
  }

  void _processQueue(BuildContext context) {
    if (_isShowing || queue.isEmpty) return;
    
    _isShowing = true;
    final item = queue.removeFirst();
    _showOverlay(context, item);
  }

  void _showOverlay(BuildContext context, NotificationItem item) {
    // Удаляем предыдущий overlay, если есть
    _currentOverlay?.remove();
    _autoHideTimer?.cancel();

    final overlay = Overlay.of(context);
    _currentOverlay = OverlayEntry(
      builder: (context) => NotificationWidget(
        item: item.getWidget(),
        duration: _duration,
        onDismiss: () => _dismissCurrent(context),
      ),
    );

    overlay.insert(_currentOverlay!);
  }

  void _dismissCurrent(BuildContext context) {
    _autoHideTimer?.cancel();
    _currentOverlay?.remove();
    _currentOverlay = null;
    _isShowing = false;
    _processQueue(context);
  }

  void clearAll() {
    queue.clear();
    _autoHideTimer?.cancel();
    _currentOverlay?.remove();
    _currentOverlay = null;
    _isShowing = false;
  }
}