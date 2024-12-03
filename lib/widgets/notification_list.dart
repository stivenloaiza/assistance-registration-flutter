import 'package:flutter/material.dart';
import 'notifications_card.dart';

class NotificationList extends StatelessWidget {
  final List<Map<String, String>> notifications;

  const NotificationList({
    Key? key,
    required this.notifications,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: notifications.length,
      itemBuilder: (context, index) {
        final notification = notifications[index];
        return CardNotification(
          title: notification['title'] ?? 'Sin título',
          subtitle: notification['subtitle'] ?? 'Sin detalles',
          timestamp: notification['timestamp'] ?? 'Sin fecha',
          notificationType: notification['type'] ?? 'default',
        );
      },
    );
  }
}
