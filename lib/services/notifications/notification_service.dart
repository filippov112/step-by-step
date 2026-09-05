import 'dart:collection';
import 'package:chaos_control/services/notifications/notification_item.dart';
import 'package:chaos_control/services/notifications/notification_widget.dart';
import 'package:flutter/material.dart';

class NotificationService extends ChangeNotifier {
  // Синглтон
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  // Контекст
  BuildContext? _context;
  void setContext(BuildContext context) {
    _context = context;
  }

  static const _duration = 2000; // Задержка

  // Очередь
  final Queue<NotificationItem> queue = Queue<NotificationItem>();
  bool _isShowing = false;

  OverlayEntry? _currentOverlay; // UI слой с уведомлением

  // Добавить уведомление в очередь
  void showNotification(NotificationItem item) {
    if (_context == null) return;
    final context = _context;
    if (context == null) return;

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
    _currentOverlay?.remove();
    _currentOverlay = null;
    _isShowing = false;
    _processQueue(context);
  }

  void clearAll() {
    queue.clear();
    _currentOverlay?.remove();
    _currentOverlay = null;
    _isShowing = false;
  }
}
