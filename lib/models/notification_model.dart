import 'package:flutter/material.dart'; // Add this line

class NotificationModel {
  final String id;
  final String title;
  final String message;
  final String type; // 'pest_alert', 'weather_alert', 'market_update', 'system', 'premium'
  final String icon;
  final DateTime timestamp;
  final bool isRead;
  final String? actionRoute;

  NotificationModel({
    required this.id,
    required this.title,
    required this.message,
    required this.type,
    required this.icon,
    required this.timestamp,
    this.isRead = false,
    this.actionRoute,
  });

  // Sample notifications for demo
  static List<NotificationModel> getSampleNotifications() {
    return [
      NotificationModel(
        id: '1',
        title: '🚨 Pest Alert: Tea Aphid Detected',
        message: 'High aphid activity detected in Kericho region. Inspect your tea bushes immediately.',
        type: 'pest_alert',
        icon: '🐛',
        timestamp: DateTime.now().subtract(const Duration(minutes: 30)),
        isRead: false,
        actionRoute: '/pest-detection',
      ),
      NotificationModel(
        id: '2',
        title: '⚠️ Weather Warning: Heavy Rain Expected',
        message: 'Heavy rainfall expected in the next 48 hours. Consider drainage and flood prevention measures.',
        type: 'weather_alert',
        icon: '🌧️',
        timestamp: DateTime.now().subtract(const Duration(hours: 2)),
        isRead: false,
        actionRoute: '/weather',
      ),
      NotificationModel(
        id: '3',
        title: '📈 Market Update: Tea Prices Rise',
        message: 'Tea prices have increased by 5% at Mombasa auction. Good time to sell your produce.',
        type: 'market_update',
        icon: '📈',
        timestamp: DateTime.now().subtract(const Duration(hours: 5)),
        isRead: true,
        actionRoute: '/market',
      ),
      NotificationModel(
        id: '4',
        title: '🌱 Farming Tip: Pruning Season',
        message: 'It\'s the best time to prune your tea bushes. Remove dead and damaged leaves for better yields.',
        type: 'system',
        icon: '✂️',
        timestamp: DateTime.now().subtract(const Duration(days: 1)),
        isRead: true,
        actionRoute: null,
      ),
      NotificationModel(
        id: '5',
        title: '🔄 Premium Feature: Pest Detection Pro',
        message: 'Upgrade to Premium for advanced pest detection AI and expert consultations.',
        type: 'premium',
        icon: '⭐',
        timestamp: DateTime.now().subtract(const Duration(days: 2)),
        isRead: true,
        actionRoute: '/premium',
      ),
    ];
  }

  Color getColor() {
    switch (type) {
      case 'pest_alert':
        return Colors.red;
      case 'weather_alert':
        return Colors.orange;
      case 'market_update':
        return Colors.green;
      case 'premium':
        return Colors.purple;
      default:
        return Colors.blue;
    }
  }

  String getTimeAgo() {
    final difference = DateTime.now().difference(timestamp);
    if (difference.inMinutes < 1) return 'Just now';
    if (difference.inMinutes < 60) return '${difference.inMinutes}m ago';
    if (difference.inHours < 24) return '${difference.inHours}h ago';
    if (difference.inDays < 7) return '${difference.inDays}d ago';
    return '${(difference.inDays / 7).floor()}w ago';
  }
}