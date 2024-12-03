import 'package:flutter/material.dart';

class CardNotification extends StatelessWidget {
  final String title;
  final String subtitle;
  final String timestamp;
  final String notificationType;

  const CardNotification({super.key, required this.title, required this.subtitle, required this.timestamp, required this.notificationType});

  IconData getIcon(){
    switch (notificationType) {
      case 'failed_login':
        return Icons.lock;
      case 'unauthorized_device':
        return Icons.warning;
      case 'long_inactivity':
        return Icons.access_time;
      default:
        return Icons.notifications;
    }
  }

  @override
  Widget build(BuildContext context) {
    final icon = getIcon();
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      color: Colors.white,
      elevation: 5,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(
              icon,
              size: 30,
              color: notificationType == 'failed_login'
                  ? Colors.red
                  : notificationType == 'unauthorized_device'
                      ? Colors.orange
                      : Colors.blue,
            ),
            const SizedBox(width: 12),
            
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    timestamp,
                    style: const TextStyle(
                      fontSize: 12,
                      color: Colors.blueGrey,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
