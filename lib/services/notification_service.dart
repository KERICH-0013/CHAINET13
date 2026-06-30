import 'package:flutter/material.dart';
import '../models/notification_model.dart';

class NotificationService extends ChangeNotifier {
  List<NotificationModel> _notifications = [];

  List<NotificationModel> get notifications => _notifications;

  int get unreadCount => _notifications.where((n) => !n.isRead).length;

  NotificationService() {
    // Load initial notifications
    _notifications = NotificationModel.getSampleNotifications();
  }

  // Add a new notification
  void addNotification(NotificationModel notification) {
    _notifications.insert(0, notification);
    notifyListeners();
  }

  // Mark as read
  void markAsRead(String id) {
    final index = _notifications.indexWhere((n) => n.id == id);
    if (index != -1) {
      final n = _notifications[index];
      _notifications[index] = NotificationModel(
        id: n.id,
        title: n.title,
        message: n.message,
        type: n.type,
        icon: n.icon,
        timestamp: n.timestamp,
        isRead: true,
        actionRoute: n.actionRoute,
      );
      notifyListeners();
    }
  }

  // Mark all as read
  void markAllAsRead() {
    _notifications = _notifications.map((n) {
      return NotificationModel(
        id: n.id,
        title: n.title,
        message: n.message,
        type: n.type,
        icon: n.icon,
        timestamp: n.timestamp,
        isRead: true,
        actionRoute: n.actionRoute,
      );
    }).toList();
    notifyListeners();
  }

  // Clear all
  void clearAll() {
    _notifications.clear();
    notifyListeners();
  }

  // Delete a notification
  void deleteNotification(String id) {
    _notifications.removeWhere((n) => n.id == id);
    notifyListeners();
  }
}