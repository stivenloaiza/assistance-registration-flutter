import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class NotificationsListTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final Color color;
  final String timestamp;
  final String documentId;

  const NotificationsListTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.color,
    required this.timestamp,
    required this.documentId,
  });

  String formattedTimestamp(String timestamp) {
    final dateTime = DateTime.parse(timestamp);
    return DateFormat('dd/MM/yyyy HH:mm').format(dateTime);
  }

  Future<void> deleteNotification(BuildContext context) async {
    try {
      await FirebaseFirestore.instance
          .collection('notifications_device')
          .doc(documentId)
          .delete();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Notificación eliminada")),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error al eliminar la notificación: $e")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 12),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 8,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Stack(
        children: [
          Row(
            children: [
              CircleAvatar(
                backgroundColor: color.withOpacity(0.1),
                child: Icon(icon, color: color),
              ),
              SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
              TextButton(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text("Detalles de la notificación"),
                        content: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(icon, color: color, size: 48),
                            SizedBox(height: 16),
                            Text(
                              title,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                              ),
                            ),
                            SizedBox(height: 8),
                            Text(
                              subtitle.isNotEmpty
                                  ? subtitle
                                  : "No hay información adicional disponible.",
                              style: TextStyle(
                                color: Colors.grey.shade700,
                                fontSize: 14,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            SizedBox(height: 16),
                            Text(
                              "Fecha: ${formattedTimestamp(timestamp)}",
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey.shade600,
                              ),
                            ),
                          ],
                        ),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.pop(context); 
                            },
                            child: Text("Cerrar"),
                          ),
                        ],
                      );
                    },
                  );
                },
                child: Text("Ver notificación"),
              ),
              SizedBox(width: 16),
              IconButton(
                icon: Icon(Icons.close, color: Colors.red),
                onPressed: () => deleteNotification(context),
                constraints: BoxConstraints(),
                padding: EdgeInsets.zero,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
