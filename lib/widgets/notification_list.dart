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
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints contraints) {
        double maxWidth = contraints.maxWidth;
        return Center(
          child: SizedBox(
            width: maxWidth > 800 ? 800 : maxWidth,
            child: ListView.builder(
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
            ),
          ),
        );
      }
    );
  }
}
