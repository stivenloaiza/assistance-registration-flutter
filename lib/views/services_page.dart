import 'package:asia_project/widgets/service_list.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class NotificationsPage extends StatefulWidget {
  @override
  _NotificationsPageState createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Opciones de filtro
  final List<String> filterOptions = [
    "Todos",
    "Dispositivos no autorizados",
    "Acceso fallido",
    "Inactividad prolongada"
  ];

  // Estado del filtro seleccionado
  String selectedFilter = "Todos";

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<Map<String, dynamic>>>(
      stream: NotificationService().getNotifications(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return Center(child: Text("Error al cargar notificaciones"));
        }

        final filteredItems = selectedFilter == "Todos"
            ? snapshot.data!
            : snapshot.data!
                .where((item) => item['title'] == selectedFilter)
                .toList();

        return Scaffold(
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Notificaciones",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () async {
                    String? selected = await showDialog<String>(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text("Selecciona un filtro"),
                          content: SingleChildScrollView(
                            child: ListBody(
                              children: filterOptions.map((filter) {
                                return GestureDetector(
                                  onTap: () {
                                    Navigator.pop(context, filter);
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(filter),
                                  ),
                                );
                              }).toList(),
                            ),
                          ),
                        );
                      },
                    );

                    if (selected != null) {
                      setState(() {
                        selectedFilter = selected;
                      });
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.filter_list, color: Colors.white, size: 20),
                      SizedBox(width: 8),
                      Text(
                        "Filtrar",
                        style: TextStyle(color: Colors.white),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 24),
                Expanded(
                  child: ListView.builder(
                    itemCount: filteredItems.length,
                    itemBuilder: (context, index) {
                      final item = filteredItems[index];
                      return NotificationsListTile(
                        icon: item['icon'],
                        title: item['title'],
                        subtitle: item['subtitle'],
                        color: item['color'],
                        timestamp: item['timestamp'],
                        documentId: item['id'],
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class NotificationService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Stream<List<Map<String, dynamic>>> getNotifications() {
    return _db.collection('notifications_device').snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        return {
          'title': (doc['title'] ?? 'Sin título').toString(),
          'subtitle': (doc['subtitle'] ?? 'Sin detalles').toString(),
          'timestamp': (doc['timestamp'] ?? 'Sin fecha').toString(),
          'type': (doc['type'] ?? 'default').toString(),
          'icon': _getIcon(doc['type'] ?? 'default'),
          'color': _getColor(doc['type'] ?? 'default'),
          'id': doc.id,
        };
      }).toList();
    });
  }
}

IconData _getIcon(String type) {
  switch (type) {
    case 'unauthorized_device':
      return Icons.warning;
    case 'failed_access':
      return Icons.lock;
    case 'long_inactivity':
      return Icons.schedule;
    default:
      return Icons.lock;
  }
}

Color _getColor(String type) {
  switch (type) {
    case 'unauthorized_device':
      return Colors.yellow;
    case 'failed_access':
      return Colors.red;
    case 'long_inactivity':
      return Colors.orange;
    default:
      return Colors.red;
  }
}
