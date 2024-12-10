import 'package:asia_project/widgets/notification_list.dart';
import 'package:flutter/material.dart';
import '../utils/burnedData/notifications.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key,});

  @override
  _NotificationsScreenState createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  String? selectedType;

  final Map<String, String> notificationTypes = {
    'Todos': 'Mostrar todo',
    'unauthorized_device': 'Dispositivo no autorizado',
    'long_inactivity': 'Inactividad prolongada',
    'failed_login': 'Acceso fallido',
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start, 
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween, 
              children: [
                const Text('Notificaciones', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                PopupMenuButton<String>(
                  onSelected: (value) {
                    setState(() {
                      selectedType = value;
                    });
                  },
                  itemBuilder: (BuildContext context) {
                    return notificationTypes.keys.map((String type) {
                      return PopupMenuItem<String>(
                        value: type,
                        child: Text(notificationTypes[type]!),
                      );
                    }).toList();
                  },
                  icon: Icon(Icons.filter_list),
                ),
              ],
            ),
          ),
          
          Expanded(
            child: NotificationList(
              notifications: _getFilteredNotifications(),
            ),
          ),
        ],
      ),
    );
  }

  List<Map<String, String>> _getFilteredNotifications() {
    if (selectedType == null || selectedType == 'Todos') {
      return notifications;
    }
    return notifications
        .where((notification) => notification['type'] == selectedType)
        .toList();
  }
}
