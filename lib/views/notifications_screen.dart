import 'package:asia_project/widgets/notification_list.dart';
import 'package:flutter/material.dart';
import '../utils/burnedData/notifications.dart';

class NotificationsScreen extends StatelessWidget {
  
  const NotificationsScreen({super.key,});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Notificaciones')),
      body: NotificationList(notifications: notifications)
    );
  }
}